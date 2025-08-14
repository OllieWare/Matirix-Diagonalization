#include <stdio.h>
#include <stddef.h>
#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>

FILE* f;
// Matrix M
int32x4_t m_1 = {1,2,3,4};
int32x4_t m_2 = {5,6,7,8};
int32x4_t m_3 = {9,10,11,12};
int32x4_t m_4 = {13,14,15,16};

// Matrix U
int32x4_t u_1 = {1,0,0,0};
int32x4_t u_2 = {0,1,0,0};
int32x4_t u_3 = {0,0,1,0};
int32x4_t u_4 = {0,0,0,1};

// Matrix V^T
int32x4_t vt_1 = {1,0,0,0};
int32x4_t vt_2 = {0,1,0,0};
int32x4_t vt_3 = {0,0,1,0};
int32x4_t vt_4 = {0,0,0,1};

// Define fixed-point angle constants (Q15 format)
#define ANGLE_0     0
#define ANGLE_22    8192
#define ANGLE_45    16384
#define ANGLE_67    24576
#define ANGLE_90    32767

// Structure to hold sin and cos values
typedef struct {
    int32_t angle_deg;
    int32_t sin_q15;
    int32_t cos_q15;
} TrigPair;

// Lookup table: angles around 0, 45, and 90 degrees
TrigPair trig_table[] = {
    { 0,    0,     32767 },     // sin(0°), cos(0°)
    { 5,    2851,  32648 },     // sin(5°), cos(5°)
    { 10,   5690,  32269 },     // sin(10°), cos(10°)
    { 15,   8513,  31631 },     // sin(15°), cos(15°)
    { 20,   11310, 30736 },      // sin(20°), cos(20°)
	{ 25,   14066, 29586 },      // sin(25°), cos(25°)
	{ 30,   16384, 28378 },      // sin(30°), cos(30°)
	{ 35,   18725, 26915 },      // sin(35°), cos(35°)
	{ 40,   21005, 25299 },      // sin(40°), cos(40°)
	{ 45,   23170, 23170 }      // sin(45°), cos(45°)
};

// Arctan degrees incrementing by 5 degrees
int32_t ARCTAN_VALS[10] = {
	0,
	2867,
	5778,
	8780,
	11926,
	15280,
	18919,
	22944,
	27496,
	32767,
};

int16x4_t rot_right;
int16x4_t rot_left;

typedef enum {
    CLOSER_TO_0,
    CLOSER_TO_45,
    CLOSER_TO_90
} AngleCategory;

// Lookup function to classify angle
AngleCategory categorize_angle(int16_t fixed_angle) {
    // Find absolute distance to each key angle
    int dist_to_0     = abs(fixed_angle - ANGLE_0);
    int dist_to_45    = abs(fixed_angle - ANGLE_45);
    int dist_to_90    = abs(fixed_angle - ANGLE_90);

    // If closest to 0
    if (dist_to_0 < dist_to_45)
        return CLOSER_TO_0;

    // If closest to 45
    if (dist_to_45 < dist_to_90) {
        return CLOSER_TO_45;
    }

    // Otherwise closest to 90
    return CLOSER_TO_90;
}

void set_rotation(int16_t angle_category) {
    TrigPair angles = trig_table[angle_category];

    rot_left = (int16x4_t) {angles.cos_q15, -angles.sin_q15, angles.sin_q15, angles.cos_q15};
    rot_right = (int16x4_t) {angles.cos_q15, angles.sin_q15, -angles.sin_q15, angles.cos_q15};
}

int32_t arctan(int32_t val,  int* flag) {
	int i;
        *flag=0;
	if (abs(val) > 32767) {
		val = 65534 - val;
		*flag=1; // to show 90-Theta needed
	}
	for (i = 0; i < 10; ++i) {
		if (abs(val) <= ARCTAN_VALS[i]) {
			return i;
		}
	}
	return -1;
//     if(abs(val)<=4096){return ANGLE_0;
// }else if(abs(val)<=8192){return ANGLE_22;
// }else if(abs(val)<=16384){return ANGLE_45;
// }else if(abs(val)<=24576){return ANGLE_67;
// }else {return ANGLE_90;//32767
//}
}

int32_t cos_t(int32_t theta) {
//printf("trig_table[0].cos_q15: %d \n",trig_table[0].cos_q15);
//printf("trig_table[1].cos_q15: %d \n",trig_table[1].cos_q15);
//printf("trig_table[2].cos_q15: %d \n",trig_table[2].cos_q15);	
return trig_table[theta].cos_q15;
//     if(theta>=ANGLE_0 && theta<ANGLE_22){return trig_table[0].cos_q15;
// }else if(theta>=ANGLE_22 && theta<ANGLE_45){return trig_table[1].cos_q15;
// }else if(theta>=ANGLE_45 && theta<ANGLE_67){return trig_table[2].cos_q15;
// }else {return trig_table[3].cos_q15;}
}

int32_t sin_t(int32_t theta) {
//printf("stheta: %d \n",theta);
return trig_table[theta].sin_q15;
//     if(theta>=ANGLE_0 && theta<ANGLE_22){return trig_table[0].sin_q15;
// }else if(theta>=ANGLE_22 && theta<ANGLE_45){return trig_table[1].sin_q15;
// }else if(theta>=ANGLE_45 && theta<ANGLE_67){return trig_table[2].sin_q15;
// }else {return trig_table[3].sin_q15;}
}

void get_rotatation(int32x2_t* R, int32_t theta, int flag) {
//printf("cos_t(theta) %d", cos_t(theta));
//printf("sin_t(theta) %d", sin_t(theta));
if (flag==0){
   R[0]= vset_lane_s32(cos_t(theta), R[0], 0);
   R[0]= vset_lane_s32(-sin_t(theta), R[0], 1);
   R[1] = vset_lane_s32(sin_t(theta), R[1], 0);
   R[1] = vset_lane_s32(cos_t(theta), R[1], 1);
} else{
R[0]= vset_lane_s32(sin_t(theta), R[0], 0);
R[0]= vset_lane_s32(-cos_t(theta), R[0], 1);
R[1] = vset_lane_s32(cos_t(theta), R[1], 0);
R[1] = vset_lane_s32(sin_t(theta), R[1], 1);
}
//printf("R11: %d \n", vget_lane_s32(R[1],1));
}

void transpose_32x2(int32x2_t* M) {
    int32x2x2_t temp;
    temp = vtrn_s32(M[0], M[1]);
    M[0] = temp.val[0];
    M[1] = temp.val[1];
}

int32_t saturate_q15(int64_t val) {
    if (val > 32767) return 32767;
    if (val < -32768) return -32768;
    return (int32_t)val;
} 





void matrix_multiply(int32x2_t* m1, int32x2_t* m2, int32x2_t* target){
int64_t N00 = (vget_lane_s32 (m1[0],0) * vget_lane_s32 (m2[0],0)) +(vget_lane_s32 (m1[0],1) * vget_lane_s32 (m2[1],0)) ;

int64_t N01 = (vget_lane_s32 (m1[0],0) * vget_lane_s32 (m2[0],1)) +(vget_lane_s32 (m1[0],1) * vget_lane_s32 (m2[1],1)) ;

int64_t N10 = (vget_lane_s32 (m1[1],0) * vget_lane_s32 (m2[0],0)) +(vget_lane_s32 (m1[1],1) * vget_lane_s32 (m2[0],1));

int64_t N11 = (vget_lane_s32 (m1[1],0) * vget_lane_s32 (m2[0],1)) +(vget_lane_s32 (m1[1],1) * vget_lane_s32 (m2[1],1));

N00 = (N00 + (1<<14)) >> 15;
N01 = (N01 + (1<<14)) >> 15;
N10 = (N10 + (1<<14)) >> 15;
N11 = (N11 + (1<<14)) >> 15;

int32_t N00_safe = saturate_q15(N00);	
int32_t N01_safe = saturate_q15(N01);
int32_t N10_safe = saturate_q15(N10);
int32_t N11_safe = saturate_q15(N11);
target[0]= vset_lane_s32((int32_t) N00_safe, target[0], 0);
target [0] = vset_lane_s32((int32_t) N01_safe, target[0], 1);
target [1]= vset_lane_s32((int32_t) N10_safe, target[1], 0);
target [1]= vset_lane_s32((int32_t) N11_safe, target[1], 1);

//printf("Target00: %.2d \n ", vget_lane_s32(target[0], 0));
//printf("Target01: %.2d \n ", vget_lane_s32(target[0], 1));
//printf("Target10: %.2d \n ", vget_lane_s32(target[1], 0));
//printf("Target11: %.2d \n ", vget_lane_s32(target[1], 1));

}
void rotate(int32x2_t* M) {
    int32_t a = vget_lane_s32(M[1], 0);
    int32_t b = vget_lane_s32(M[0], 1);
    int sum_denom = (vget_lane_s32(M[1], 1) - vget_lane_s32(M[0],0));
    int dif_denom = (vget_lane_s32(M[1], 1) + vget_lane_s32(M[0],0));
    int64_t numerator;
    int sum;
    if (sum_denom!=0){ 
    numerator = ((int64_t)(a + b) << 15);
    sum = (int32_t)((numerator + (sum_denom >> 1)) / sum_denom);
    }else{sum=32767;}
    int dif;
    if (dif_denom!=0){
    numerator = ((int64_t)(a - b) << 15);
    dif = (int32_t)((numerator + (dif_denom >> 1)) /dif_denom);
    }else{dif=32767;}
    //printf("sum: %d \n",sum);
    //printf("dif: %d \n",dif);

    int sum_mirror;
    int dif_mirror;
    sum = arctan(sum,&sum_mirror) * 5;
    dif = arctan(dif,&dif_mirror) * 5;
    int mirror_L=sum_mirror;
    int mirror_R=(sum_mirror+dif_mirror);
    //printf("sum_tan: %d \n",sum);
    //printf("dif_tan: %d \n",dif);
    int theta_r = (sum + dif) >> 2;
    printf("R_Angle %d \n",theta_r);
    int theta_l = sum - theta_r;
    printf("L_Angle %d \n",theta_l);
	theta_r = theta_r / 5;
	theta_l = theta_l / 5;
    if(theta_r<=0){theta_r=1;mirror_L++;}else if(theta_r>9){theta_r=9; mirror_R++;}
    if(theta_l<=0){theta_l=1; mirror_L++;}else if(theta_l>9){theta_l=9; mirror_L++;}
    printf("R_Index %d \n",theta_r);
    printf("L_Index %d \n",theta_l);
    int32x2_t R_L[2] = { {}, {} };
    int32x2_t R_R[2] = { {}, {} };
    get_rotatation(R_L, theta_l, 0);
    get_rotatation(R_R, theta_r, 0);
    transpose_32x2(R_R);

//Matrix Multiply R_L x M x R_R
int32x2_t temp[2]={{},{}};
matrix_multiply(R_L,M,temp);
matrix_multiply(temp,R_R,M);
//printf("M:%.2d \n ", vget_lane_s32(M[1], 1));
//printf("L00:%.2d \n ", vget_lane_s32(R_L[0], 0));
//printf("L01:%.2d \n ", vget_lane_s32(R_L[0], 1));
//printf("L10:%.2d \n ", vget_lane_s32(R_L[1], 0));
//printf("L11:%.2d \n ", vget_lane_s32(R_L[1], 1));
//printf("R00:%.2d \n ", vget_lane_s32(R_R[0], 0));
//printf("R01:%.2d \n ", vget_lane_s32(R_R[0], 1));
//printf("R10:%.2d \n ", vget_lane_s32(R_R[1], 0));
//printf("R11:%.2d \n ", vget_lane_s32(R_R[1], 1));
}

void transpose_32x4x4(int32x4_t* M) {
    int32x2_t ah = vget_high_s32(M[0]);
    int32x2_t al = vget_low_s32(M[0]);
    int32x2_t bh = vget_high_s32(M[1]);
    int32x2_t bl = vget_low_s32(M[1]);
    int32x2_t ch = vget_high_s32(M[2]);
    int32x2_t cl = vget_low_s32(M[2]);
    int32x2_t dh = vget_high_s32(M[3]);
    int32x2_t dl = vget_low_s32(M[3]);
    int32x4_t aa = vcombine_s32(al, cl);
    int32x4_t bb = vcombine_s32(bl, dl);
    int32x4_t cc = vcombine_s32(ah, ch);
    int32x4_t dd = vcombine_s32(bh, dh);
    M[0] = aa;
    M[1] = bb;
    M[2] = cc;
    M[3] = dd;
}

void transpose_32x2x2(int32x4_t* M) {
    int32x4x2_t temp;
    temp = vtrnq_s32(M[0], M[1]);
    M[0] = temp.val[0];
    M[1] = temp.val[1];
}

void transpose_32x4(int32x4_t* M) {
    // int32x4x2_t temp;
    // temp = vtrnq_s32(M[0], M[1]);
    // M[0] = temp.val[0];
    // M[1] = temp.val[1];
    transpose_32x2x2(M);
    // temp = vtrnq_s32(M[2], M[3]);
    // M[2] = temp.val[0];
    // M[3] = temp.val[1];
    transpose_32x2x2(M+2);
    // int32x2_t ah = vget_high_s32(M[0]);
    // int32x2_t al = vget_low_s32(M[0]);
    // int32x2_t bh = vget_high_s32(M[1]);
    // int32x2_t bl = vget_low_s32(M[1]);
    // int32x2_t ch = vget_high_s32(M[2]);
    // int32x2_t cl = vget_low_s32(M[2]);
    // int32x2_t dh = vget_high_s32(M[3]);
    // int32x2_t dl = vget_low_s32(M[3]);
    // int32x4_t aa = vcombine_s32(al, cl);
    // int32x4_t bb = vcombine_s32(bl, dl);
    // int32x4_t cc = vcombine_s32(ah, ch);
    // int32x4_t dd = vcombine_s32(bh, dh);
    // M[0] = aa;
    // M[1] = bb;
    // M[2] = cc;
    // M[3] = dd;
    transpose_32x4x4(M);
}

int main() {
    // f = fopen("matrix.txt", "r");
    // if ((f == NULL)) {
    //     printf("Error reading file\n");
    //     fclose(f);
    //     return 1;  
    // }
    // fclose(f);
    int32x4_t U[4] = {u_1, u_2, u_3, u_4};
    int32x4_t VT[4] = {vt_1, vt_2, vt_3, vt_4};
    int32x4_t M[4] = {m_1, m_2, m_3, m_4};
    int i;
    int j;
    for (i=0; i<4; i++){	
    	for (j = 0; j < 4; j++) {
    		switch (j){
    //case 0: printf("%.2d ", vgetq_lane_s32(M[i], 0)); break;
    //case 1: printf("%.2d ", vgetq_lane_s32(M[i], 1)); break;
    //case 2: printf("%.2d ", vgetq_lane_s32(M[i], 2)); break;
    //case 3:  printf("%.2d ", vgetq_lane_s32(M[i], 3)); break;
    		}
    	}
    	printf("\n");
    }
    transpose_32x4(M);
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 4; j++) {
            switch(j) {
	//	case 0: printf("%.2d ", vgetq_lane_s32(M[i], 0)); break;
	//	case 1: printf("%.2d ", vgetq_lane_s32(M[i], 1)); break;
	//	case 2: printf("%.2d ", vgetq_lane_s32(M[i], 2)); break;
	//	case 3: printf("%.2d ", vgetq_lane_s32(M[i], 3)); break;
          	}
        }
        printf("\n");
    }
    printf("\n");

// 		2x2 Matrix Test
	// ------------------
 //    int32x2_t test_rotate[2] = {{0,32767},{-32767,0}};
 //    int k;
 //    for(k=0; k<5; k++){
 //    rotate(test_rotate);
 //    printf("Rotation %d: \n",k+1);
 //    for(i=0;i<2;i++){
 //        for(j=0;j<2;j++) {
 //           switch(j) {
 //           case 0: printf("%.2d ", vget_lane_s32(test_rotate[i], 0)); break;
 //           case 1: printf("%.2d ", vget_lane_s32(test_rotate[i], 1)); break;
 //           }
	// 	}
	// 	printf("\n");
	// } 
    return 0;
}
