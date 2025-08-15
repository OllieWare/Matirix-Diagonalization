#include <stdio.h>
#include <stddef.h>
#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>

FILE* f;
// Matrix M
int32x4_t m_1 = {31 , 77 , -11 , 26 };
int32x4_t m_2 = {-42 , 14 , 79 , -53 };
int32x4_t m_3 = {-68 , -10 , 45 , 90 };
int32x4_t m_4 = {34 , 16 , 38 , -19 };

// Matrix U
int32x4_t u_1 = {32767,0,0,0};
int32x4_t u_2 = {0,32767,0,0};
int32x4_t u_3 = {0,0,32767,0};
int32x4_t u_4 = {0,0,0,32767};

// Matrix V^T
int32x4_t vt_1 = {32767,0,0,0};
int32x4_t vt_2 = {0,32767,0,0};
int32x4_t vt_3 = {0,0,32767,0};
int32x4_t vt_4 = {0,0,0,32767};

// Define fixed-point angle constants (Q15 format)
#define ANGLE_0     0
#define ANGLE_22    8192
#define ANGLE_45    16384
#define ANGLE_67    24576
#define ANGLE_90    32767

// Constants for Diagonalization sweeps
#define MAX_SWEEPS 			  	20
#define CONVERGENCE_THRESHOLD 	1000

// Structure to hold sin and cos values
typedef struct {
    int32_t angle_deg;
    int32_t sin_q15;
    int32_t cos_q15;
} TrigPair;

// Lookup table: angles around 0, 45, and 90 degrees
TrigPair trig_table[46] = {
    {  0,     0,    32767 },
    {  1,    572,   32766 },
    {  2,   1144,   32758 },
    {  3,   1716,   32744 },
    {  4,   2287,   32723 },
    {  5,   2858,   32695 },
    {  6,   3429,   32660 },
    {  7,   3999,   32618 },
    {  8,   4569,   32570 },
    {  9,   5139,   32514 },
    { 10,   5708,   32452 },
    { 11,   6276,   32383 },
    { 12,   6844,   32307 },
    { 13,   7411,   32224 },
    { 14,   7977,   32134 },
    { 15,   8543,   32037 },
    { 16,   9108,   31933 },
    { 17,   9672,   31822 },
    { 18,  10235,   31704 },
    { 19,  10797,   31579 },
    { 20,  11358,   31447 },
    { 21,  11918,   31308 },
    { 22,  12477,   31162 },
    { 23,  13035,   31009 },
    { 24,  13591,   30849 },
    { 25,  14146,   30682 },
    { 26,  14700,   30508 },
    { 27,  15252,   30327 },
    { 28,  15803,   30139 },
    { 29,  16352,   29944 },
    { 30,  16900,   29742 },
    { 31,  17446,   29533 },
    { 32,  17990,   29317 },
    { 33,  18533,   29094 },
    { 34,  19073,   28864 },
    { 35,  19612,   28627 },
    { 36,  20149,   28383 },
    { 37,  20684,   28132 },
    { 38,  21217,   27874 },
    { 39,  21748,   27609 },
    { 40,  22276,   27337 },
    { 41,  22803,   27058 },
    { 42,  23327,   26772 },
    { 43,  23849,   26479 },
    { 44,  24368,   26179 },
    { 45,  24885,   25872 }
};

// Arctan degrees incrementing by 5 degrees
int32_t ARCTAN_VALS[46] = {
     0,     // tan(0°)
     572,   // tan(1°)
    1144,   // tan(2°)
    1716,   // tan(3°)
    2289,   // tan(4°)
    2862,   // tan(5°)
    3436,   // tan(6°)
    4010,   // tan(7°)
    4585,   // tan(8°)
    5161,   // tan(9°)
    5738,   // tan(10°)
    6316,   // tan(11°)
    6895,   // tan(12°)
    7475,   // tan(13°)
    8056,   // tan(14°)
    8639,   // tan(15°)
    9223,   // tan(16°)
    9808,   // tan(17°)
   10394,   // tan(18°)
   10982,   // tan(19°)
   11571,   // tan(20°)
   12162,   // tan(21°)
   12754,   // tan(22°)
   13348,   // tan(23°)
   13943,   // tan(24°)
   14540,   // tan(25°)
   15138,   // tan(26°)
   15738,   // tan(27°)
   16340,   // tan(28°)
   16943,   // tan(29°)
   17548,   // tan(30°)
   18155,   // tan(31°)
   18763,   // tan(32°)
   19373,   // tan(33°)
   19985,   // tan(34°)
   20598,   // tan(35°)
   21213,   // tan(36°)
   21830,   // tan(37°)
   22448,   // tan(38°)
   23068,   // tan(39°)
   23690,   // tan(40°)
   24313,   // tan(41°)
   24938,   // tan(42°)
   25565,   // tan(43°)
   26193,   // tan(44°)
   32767    // tan(45°) → ∞ in theory, clamped to max Q15
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
	if (val > 32767 || val<-32768) {
		val = 32767;
		*flag=1; // to show 90-Theta needed
	}
	for (i = 0; i < 46; ++i) {
		if (abs(val) <= ARCTAN_VALS[i]) {
			return i;
		}
	}
	return -1;
}

int32_t cos_t(int32_t theta) {
	return trig_table[theta].cos_q15;
}

int32_t sin_t(int32_t theta) {
	return trig_table[theta].sin_q15;
}

void get_rotatation(int32x2_t* R, int32_t theta, int flag) {
//printf("cos_t(theta) %d", cos_t(theta));
//printf("sin_t(theta) %d", sin_t(theta));
if (theta>=0){
   R[0]= vset_lane_s32(cos_t(theta), R[0], 0);
   R[0]= vset_lane_s32(-sin_t(theta), R[0], 1);
   R[1] = vset_lane_s32(sin_t(theta), R[1], 0);
   R[1] = vset_lane_s32(cos_t(theta), R[1], 1);
} else{
R[0]= vset_lane_s32(cos_t(theta), R[0], 0);
R[0]= vset_lane_s32(sin_t(theta), R[0], 1);
R[1] = vset_lane_s32(-sin_t(theta), R[1], 0);
R[1] = vset_lane_s32(cos_t(theta), R[1], 1);
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

int32_t get_lane(int32x4_t vec, int index) {
    switch (index) {
        case 0: return vgetq_lane_s32(vec, 0);
        case 1: return vgetq_lane_s32(vec, 1);
        case 2: return vgetq_lane_s32(vec, 2);
        case 3: return vgetq_lane_s32(vec, 3);
        default: return 0; // Should never happen
    }
}

int32x4_t set_lane(int32x4_t vec, int32_t value, int index) {
    switch (index) {
        case 0: return vsetq_lane_s32(value, vec, 0);
        case 1: return vsetq_lane_s32(value, vec, 1);
        case 2: return vsetq_lane_s32(value, vec, 2);
        case 3: return vsetq_lane_s32(value, vec, 3);
        default: return vec; // Should never happen
    }
}

void matrix_multiply_4x4(int32x4_t* m1, int32x4_t* m2, int32x4_t* target) {
	int32x4_t temp[4] = {};
    for (int i = 0; i < 4; i++) { // Row of m1
        int32x4_t row_result = vdupq_n_s32(0); // Initialize result row
        for (int j = 0; j < 4; j++) { // Column of m2
            int64_t sum = 0;
            for (int k = 0; k < 4; k++) {
                int32_t a, b;

                // Get m1[i][k]
                switch (k) {
                    case 0: a = vgetq_lane_s32(m1[i], 0); break;
                    case 1: a = vgetq_lane_s32(m1[i], 1); break;
                    case 2: a = vgetq_lane_s32(m1[i], 2); break;
                    case 3: a = vgetq_lane_s32(m1[i], 3); break;
                }

                // Get m2[k][j]
                switch (j) {
                    case 0: b = vgetq_lane_s32(m2[k], 0); break;
                    case 1: b = vgetq_lane_s32(m2[k], 1); break;
                    case 2: b = vgetq_lane_s32(m2[k], 2); break;
                    case 3: b = vgetq_lane_s32(m2[k], 3); break;
                }
				//printf("A is: %.2d\n", a);
				//printf("B is: %.2d\n", b);
				//printf("\n");
                sum += (int64_t)a * b;
				//printf("Sum is: %.2d\n", sum);
				//printf("\n");
            }

            // Fixed-point rounding
            sum = (sum + (1 << 14)) >> 15;

            // Saturate to Q15
            int32_t safe = saturate_q15(sum);

            // Set row_result[j]
            switch (j) {
                case 0: row_result = vsetq_lane_s32(safe, row_result, 0); break;
                case 1: row_result = vsetq_lane_s32(safe, row_result, 1); break;
                case 2: row_result = vsetq_lane_s32(safe, row_result, 2); break;
                case 3: row_result = vsetq_lane_s32(safe, row_result, 3); break;
            }
        }
        temp[i] = row_result;
    }
	for (int i = 0; i < 4; i++) {
		target[i] = temp[i];
	}
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
void rotate(int32x2_t* N, int32x4_t* M, int32x4_t* U, int32x4_t* VT) {
    int32_t a = vget_lane_s32(N[1], 0);
    int32_t b = vget_lane_s32(N[0], 1);
    int sum_denom = (vget_lane_s32(N[1], 1) - vget_lane_s32(N[0],0));
    int dif_denom = (vget_lane_s32(N[1], 1) + vget_lane_s32(N[0],0));
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
    sum = arctan(sum,&sum_mirror);
    dif = arctan(dif,&dif_mirror);
    int mirror_L=sum_mirror;
    int mirror_R=(sum_mirror+dif_mirror);
    //printf("sum_tan: %d \n",sum);
    //printf("dif_tan: %d \n",dif);
    int theta_r = (sum + dif) >> 2;
    //printf("R_Angle %d \n",theta_r);
    int theta_l = sum - theta_r;
    //printf("L_Angle %d \n",theta_l);
	theta_r = theta_r;
	theta_l = theta_l;
    if(theta_r<=-45){theta_r=-45;mirror_L++;}else if(theta_r>45){theta_r=45; mirror_R++;}
    if(theta_l<=-45){theta_l=-45; mirror_L++;}else if(theta_l>45){theta_l=45; mirror_L++;}
    //printf("R_Index %d \n",theta_r);
    //printf("L_Index %d \n",theta_l);
    int32x2_t R_L[2] = { {}, {} };
    int32x2_t R_R[2] = { {}, {} };
    get_rotatation(R_L, theta_l, 0);
    get_rotatation(R_R, theta_r, 0);
    transpose_32x2(R_R);

	//Matrix Multiply R_L x M x R_R
	int32x2_t temp_prime[2]={{},{}};
	matrix_multiply(R_L,N,temp_prime);
	matrix_multiply(temp_prime,R_R,N);
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
    transpose_32x2x2(M);
	int32x4_t temp[2] = {M[2], M[3]};
    transpose_32x2x2(temp);
	M[2] = temp[2];
	M[3] = temp[3];
    transpose_32x4x4(M);
}

int32_t max_off_diag(int32x4_t* M) {
    int32_t max_val = 0;
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            if (i != j) {
				int32_t val;
				switch(j) {
					case 0: val = abs(vgetq_lane_s32(M[i], 0)); break;
					case 1: val = abs(vgetq_lane_s32(M[i], 1)); break;
					case 2: val = abs(vgetq_lane_s32(M[i], 2)); break;
					case 3: val = abs(vgetq_lane_s32(M[i], 3)); break;
				}
                if (val > max_val) max_val = val;
            }
        }
    }
    return max_val;
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
	int sweep_count = 0;
	while (sweep_count < MAX_SWEEPS && max_off_diag(M) > CONVERGENCE_THRESHOLD) {
		sweep_count++;
	    int i;
	    int j;
	    for (i = 0; i < 3; i++){
	    	for (j = i + 1; j < 4; j++) {
		 		int32x2_t temp[2]= {{},{}};
	    		switch (i){
				    case 0: 
						switch(j) {
						    case 1:
								temp[0] = vset_lane_s32(vgetq_lane_s32(M[i],0),temp[0], 0);
								temp[0] = vset_lane_s32(vgetq_lane_s32(M[i],1),temp[0], 1);
								temp[1] = vset_lane_s32(vgetq_lane_s32(M[j],0),temp[1], 0);
								temp[1] = vset_lane_s32(vgetq_lane_s32(M[j],1),temp[1], 1);
								break;
						    case 2:
								temp[0] = vset_lane_s32(vgetq_lane_s32(M[i],0),temp[0], 0);
								temp[0] = vset_lane_s32(vgetq_lane_s32(M[i],2),temp[0], 1);
								temp[1] = vset_lane_s32(vgetq_lane_s32(M[j],0),temp[1], 0);
								temp[1] = vset_lane_s32(vgetq_lane_s32(M[j],2),temp[1], 1);
								break;
							case 3:
								temp[0] = vset_lane_s32(vgetq_lane_s32(M[i],0),temp[0], 0);
								temp[0] = vset_lane_s32(vgetq_lane_s32(M[i],3),temp[0], 1);
								temp[1] = vset_lane_s32(vgetq_lane_s32(M[j],0),temp[1], 0);
								temp[1] = vset_lane_s32(vgetq_lane_s32(M[j],3),temp[1], 1);
								break;
						}
						break;
				    case 1:
						switch(j) {
						    case 2:
								temp[0] = vset_lane_s32(vgetq_lane_s32(M[i],1),temp[0], 0);
								temp[0] = vset_lane_s32(vgetq_lane_s32(M[i],2),temp[0], 1);
								temp[1] = vset_lane_s32(vgetq_lane_s32(M[j],1),temp[1], 0);
								temp[1] = vset_lane_s32(vgetq_lane_s32(M[j],2),temp[1], 1);
								break;
							case 3:
								temp[0] = vset_lane_s32(vgetq_lane_s32(M[i],1),temp[0], 0);
								temp[0] = vset_lane_s32(vgetq_lane_s32(M[i],3),temp[0], 1);
								temp[1] = vset_lane_s32(vgetq_lane_s32(M[j],1),temp[1], 0);
								temp[1] = vset_lane_s32(vgetq_lane_s32(M[j],3),temp[1], 1);
								break;
						}
						break;
				    case 2:
						temp[0] = vset_lane_s32(vgetq_lane_s32(M[i],2),temp[0], 0);
						temp[0] = vset_lane_s32(vgetq_lane_s32(M[i],3),temp[0], 1);
						temp[1] = vset_lane_s32(vgetq_lane_s32(M[j],2),temp[1], 0);
						temp[1] = vset_lane_s32(vgetq_lane_s32(M[j],3),temp[1], 1);
						break;
	    		}
				int k;
				int l;
				/*
				for(k=0;k<2;k++){
	        		for(l=0;l<2;l++) {
	           			switch(l) {
	           				case 0: printf("%.2d ", vget_lane_s32(temp[k], 0)); break;
	           				case 1: printf("%.2d ", vget_lane_s32(temp[k], 1)); break;
	           			}
					}
					printf("\n");
				}
				printf("\n");
				*/
				// Rotate the 2x2 Matrix
				int32_t a = vget_lane_s32(temp[1], 0);
			    int32_t b = vget_lane_s32(temp[0], 1);
			    int sum_denom = (vget_lane_s32(temp[1], 1) - vget_lane_s32(temp[0],0));
			    int dif_denom = (vget_lane_s32(temp[1], 1) + vget_lane_s32(temp[0],0));
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
			    //printf("R_Angle %d \n",theta_r);
			    int theta_l = sum - theta_r;
			    //printf("L_Angle %d \n",theta_l);
				theta_r = theta_r / 5;
				theta_l = theta_l / 5;
			    if(theta_r<=0){theta_r=1;mirror_L++;}else if(theta_r>9){theta_r=9; mirror_R++;}
			    if(theta_l<=0){theta_l=1; mirror_L++;}else if(theta_l>9){theta_l=9; mirror_L++;}
			    //printf("R_Index %d \n",theta_r);
			   // printf("L_Index %d \n",theta_l);
			    int32x2_t R_L[2] = { {}, {} };
			    int32x2_t R_R[2] = { {}, {} };
			    get_rotatation(R_L, theta_l, 0);
			    get_rotatation(R_R, theta_r, 0);
			    transpose_32x2(R_R);
			
				//Matrix Multiply R_L x M x R_R
				int32x2_t temp_prime[2]={{},{}};
				matrix_multiply(R_L,temp,temp_prime);
				matrix_multiply(temp_prime,R_R,temp);
	
				// Reset R_R
				transpose_32x2(R_R);
				int32x4_t U_prime[4] = {
					{32767,0,0,0},
					{0,32767,0,0},
					{0,0,32767,0},
					{0,0,0,32767}
				};
				int32x4_t VT_prime[4] = {
					{32767,0,0,0},
					{0,32767,0,0},
					{0,0,32767,0},
					{0,0,0,32767}
				};
				switch(i) {
					case 0:
						switch(j) {
							case 1:
								U_prime[i] = vsetq_lane_s32(vget_lane_s32(R_L[0],0),U_prime[i], 0);
								U_prime[i] = vsetq_lane_s32(vget_lane_s32(R_L[0],1),U_prime[i], 1);
								U_prime[j] = vsetq_lane_s32(vget_lane_s32(R_L[1],0),U_prime[j], 0);
								U_prime[j] = vsetq_lane_s32(vget_lane_s32(R_L[1],1),U_prime[j], 1);
								
							    VT_prime[i] = vsetq_lane_s32(vget_lane_s32(R_R[0],0),VT_prime[i], 0);
								VT_prime[i] = vsetq_lane_s32(vget_lane_s32(R_R[0],1),VT_prime[i], 1);
								VT_prime[j] = vsetq_lane_s32(vget_lane_s32(R_R[1],0),VT_prime[j], 0);
								VT_prime[j] = vsetq_lane_s32(vget_lane_s32(R_R[1],1),VT_prime[j], 1);
								break;
							case 2:
							    U_prime[i] = vsetq_lane_s32(vget_lane_s32(R_L[0],0),U_prime[i], 0);
								U_prime[i] = vsetq_lane_s32(vget_lane_s32(R_L[0],1),U_prime[i], 2);
								U_prime[j] = vsetq_lane_s32(vget_lane_s32(R_L[1],0),U_prime[j], 0);
								U_prime[j] = vsetq_lane_s32(vget_lane_s32(R_L[1],1),U_prime[j], 2);
								
							    VT_prime[i] = vsetq_lane_s32(vget_lane_s32(R_R[0],0),VT_prime[i], 0);
								VT_prime[i] = vsetq_lane_s32(vget_lane_s32(R_R[0],1),VT_prime[i], 2);
								VT_prime[j] = vsetq_lane_s32(vget_lane_s32(R_R[1],0),VT_prime[j], 0);
								VT_prime[j] = vsetq_lane_s32(vget_lane_s32(R_R[1],1),VT_prime[j], 2);
								break;
							case 3:
							    U_prime[i] = vsetq_lane_s32(vget_lane_s32(R_L[0],0),U_prime[i], 0);
								U_prime[i] = vsetq_lane_s32(vget_lane_s32(R_L[0],1),U_prime[i], 3);
								U_prime[j] = vsetq_lane_s32(vget_lane_s32(R_L[1],0),U_prime[j], 0);
								U_prime[j] = vsetq_lane_s32(vget_lane_s32(R_L[1],1),U_prime[j], 3);
								
							    VT_prime[i] = vsetq_lane_s32(vget_lane_s32(R_R[0],0),VT_prime[i], 0);
								VT_prime[i] = vsetq_lane_s32(vget_lane_s32(R_R[0],1),VT_prime[i], 3);
								VT_prime[j] = vsetq_lane_s32(vget_lane_s32(R_R[1],0),VT_prime[j], 0);
								VT_prime[j] = vsetq_lane_s32(vget_lane_s32(R_R[1],1),VT_prime[j], 3);
								break;
						}
						break;
					case 1:
						switch(j) {
							case 2:
							    U_prime[i] = vsetq_lane_s32(vget_lane_s32(R_L[0],0),U_prime[i], 1);
								U_prime[i] = vsetq_lane_s32(vget_lane_s32(R_L[0],1),U_prime[i], 2);
								U_prime[j] = vsetq_lane_s32(vget_lane_s32(R_L[1],0),U_prime[j], 1);
								U_prime[j] = vsetq_lane_s32(vget_lane_s32(R_L[1],1),U_prime[j], 2);
								
							    VT_prime[i] = vsetq_lane_s32(vget_lane_s32(R_R[0],0),VT_prime[i], 1);
								VT_prime[i] = vsetq_lane_s32(vget_lane_s32(R_R[0],1),VT_prime[i], 2);
								VT_prime[j] = vsetq_lane_s32(vget_lane_s32(R_R[1],0),VT_prime[j], 1);
								VT_prime[j] = vsetq_lane_s32(vget_lane_s32(R_R[1],1),VT_prime[j], 2);
								break;
							case 3:
							    U_prime[i] = vsetq_lane_s32(vget_lane_s32(R_L[0],0),U_prime[i], 1);
								U_prime[i] = vsetq_lane_s32(vget_lane_s32(R_L[0],1),U_prime[i], 3);
								U_prime[j] = vsetq_lane_s32(vget_lane_s32(R_L[1],0),U_prime[j], 1);
								U_prime[j] = vsetq_lane_s32(vget_lane_s32(R_L[1],1),U_prime[j], 3);
								
							    VT_prime[i] = vsetq_lane_s32(vget_lane_s32(R_R[0],0),VT_prime[i], 1);
								VT_prime[i] = vsetq_lane_s32(vget_lane_s32(R_R[0],1),VT_prime[i], 3);
								VT_prime[j] = vsetq_lane_s32(vget_lane_s32(R_R[1],0),VT_prime[j], 1);
								VT_prime[j] = vsetq_lane_s32(vget_lane_s32(R_R[1],1),VT_prime[j], 3);
								break;
						}
						break;
					case 2:
						U_prime[i] = vsetq_lane_s32(vget_lane_s32(R_L[0],0),U_prime[i], 2);
						U_prime[i] = vsetq_lane_s32(vget_lane_s32(R_L[0],1),U_prime[i], 3);
						U_prime[j] = vsetq_lane_s32(vget_lane_s32(R_L[1],0),U_prime[j], 2);
						U_prime[j] = vsetq_lane_s32(vget_lane_s32(R_L[1],1),U_prime[j], 3);
						
						VT_prime[i] = vsetq_lane_s32(vget_lane_s32(R_R[0],0),VT_prime[i], 2);
						VT_prime[i] = vsetq_lane_s32(vget_lane_s32(R_R[0],1),VT_prime[i], 3);
						VT_prime[j] = vsetq_lane_s32(vget_lane_s32(R_R[1],0),VT_prime[j], 2);
						VT_prime[j] = vsetq_lane_s32(vget_lane_s32(R_R[1],1),VT_prime[j], 3);
						break;
				}
				/*
				printf("Matrix U_prime:\n");
				for(k=0;k<4;k++){
	        		for(l=0;l<4;l++) {
	           			switch(l) {
	           				case 0: printf("%.2d ", vgetq_lane_s32(U_prime[k], 0)); break;
	           				case 1: printf("%.2d ", vgetq_lane_s32(U_prime[k], 1)); break;
							case 2: printf("%.2d ", vgetq_lane_s32(U_prime[k], 2)); break;
	           				case 3: printf("%.2d ", vgetq_lane_s32(U_prime[k], 3)); break;
	           			}
					}
					printf("\n");
				}
				printf("\n");
				*/
				// printf("Matrix VT_primeT:\n");
				// for(k=0;k<4;k++){
	   //      		for(l=0;l<4;l++) {
	   //         			switch(l) {
	   //         				case 0: printf("%.2d ", vgetq_lane_s32(VT_prime[k], 0)); break;
	   //         				case 1: printf("%.2d ", vgetq_lane_s32(VT_prime[k], 1)); break;
				// 			case 2: printf("%.2d ", vgetq_lane_s32(VT_prime[k], 2)); break;
	   //         				case 3: printf("%.2d ", vgetq_lane_s32(VT_prime[k], 3)); break;
	   //         			}
				// 	}
				// 	printf("\n");
				// }
				// printf("\n");
				
				int32x4_t M_prime[4] = {{}, {}, {}, {}};
				int32x4_t aa;
			    int32x4_t bb;
			    int32x4_t cc;
			    int32x4_t dd;
				int n;
					
				// Transpose VT
				int32x4x2_t temp_VT;
			    temp_VT = vtrnq_s32(VT[0], VT[1]);
			    VT[0] = temp_VT.val[0];
			    VT[1] = temp_VT.val[1];
			    temp_VT = vtrnq_s32(VT[2], VT[3]);
			    VT[2] = temp_VT.val[0];
			    VT[3] = temp_VT.val[1];
			    aa = vcombine_s32(vget_low_s32(VT[0]), vget_low_s32(VT[2]));
			    bb = vcombine_s32(vget_low_s32(VT[1]), vget_low_s32(VT[3]));
			    cc = vcombine_s32(vget_high_s32(VT[0]), vget_high_s32(VT[2]));
			    dd = vcombine_s32(vget_high_s32(VT[1]), vget_high_s32(VT[3]));
				VT[0] = aa;
				VT[1] = bb;
				VT[2] = cc;
				VT[3] = dd;
				//transpose_32x4(VT);
				
				// printf("Matrix VT after transpose:\n");
				// for(k=0;k<4;k++){
	   //      		for(l=0;l<4;l++) {
	   //         			switch(l) {
	   //         				case 0: printf("%.2d ", vgetq_lane_s32(VT[k], 0)); break;
	   //         				case 1: printf("%.2d ", vgetq_lane_s32(VT[k], 1)); break;
				// 			case 2: printf("%.2d ", vgetq_lane_s32(VT[k], 2)); break;
	   //         				case 3: printf("%.2d ", vgetq_lane_s32(VT[k], 3)); break;
	   //         			}
				// 	}
				// 	printf("\n");
				// }
				// printf("\n");
				
				matrix_multiply_4x4(VT_prime, VT, VT);
				// printf("Matrix VT after mult:\n");
				// for(k=0;k<4;k++){
	   //      		for(l=0;l<4;l++) {
	   //         			switch(l) {
	   //         				case 0: printf("%.2d ", vgetq_lane_s32(VT[k], 0)); break;
	   //         				case 1: printf("%.2d ", vgetq_lane_s32(VT[k], 1)); break;
				// 			case 2: printf("%.2d ", vgetq_lane_s32(VT[k], 2)); break;
	   //         				case 3: printf("%.2d ", vgetq_lane_s32(VT[k], 3)); break;
	   //         			}
				// 	}
				// 	printf("\n");
				// }
				// printf("\n");
				
				matrix_multiply_4x4(U_prime, M, M_prime);
	
				// Transpose VT_prime
				int32x4x2_t temp_VT_prime;
			    temp_VT_prime = vtrnq_s32(VT_prime[0], VT_prime[1]);
			    VT_prime[0] = temp_VT_prime.val[0];
			    VT_prime[1] = temp_VT_prime.val[1];
			    temp_VT_prime = vtrnq_s32(VT_prime[2], VT_prime[3]);
			    VT_prime[2] = temp_VT_prime.val[0];
			    VT_prime[3] = temp_VT_prime.val[1];
			    aa = vcombine_s32(vget_low_s32(VT_prime[0]), vget_low_s32(VT_prime[2]));
			    bb = vcombine_s32(vget_low_s32(VT_prime[1]), vget_low_s32(VT_prime[3]));
			    cc = vcombine_s32(vget_high_s32(VT_prime[0]), vget_high_s32(VT_prime[2]));
			    dd = vcombine_s32(vget_high_s32(VT_prime[1]), vget_high_s32(VT_prime[3]));
				VT_prime[0] = aa;
				VT_prime[1] = bb;
				VT_prime[2] = cc;
				VT_prime[3] = dd;
				//transpose_32x4(VT_prime);
				
				matrix_multiply_4x4(M_prime, VT_prime, M);
	
				// Transpose U_prime
				int32x4x2_t temp_U_prime;
			    temp_U_prime = vtrnq_s32(U_prime[0], U_prime[1]);
			    U_prime[0] = temp_U_prime.val[0];
			    U_prime[1] = temp_U_prime.val[1];
			    temp_U_prime = vtrnq_s32(U_prime[2], U_prime[3]);
			    U_prime[2] = temp_U_prime.val[0];
			    U_prime[3] = temp_U_prime.val[1];
			    aa = vcombine_s32(vget_low_s32(U_prime[0]), vget_low_s32(U_prime[2]));
			    bb = vcombine_s32(vget_low_s32(U_prime[1]), vget_low_s32(U_prime[3]));
			    cc = vcombine_s32(vget_high_s32(U_prime[0]), vget_high_s32(U_prime[2]));
			    dd = vcombine_s32(vget_high_s32(U_prime[1]), vget_high_s32(U_prime[3]));
				U_prime[0] = aa;
				U_prime[1] = bb;
				U_prime[2] = cc;
				U_prime[3] = dd;
				//transpose_32x4(U_prime);
				
				matrix_multiply_4x4(U, U_prime, U);
	    	}
	    	printf("\n");
	    }
		printf("Sweep %d of Matrix M:\n", sweep_count);
		int k;
		int l;
		for(k=0;k<4;k++){
			for(l=0;l<4;l++) {
				switch(l) {
					case 0: printf("%.2d ", vgetq_lane_s32(M[k], 0)); break;
					case 1: printf("%.2d ", vgetq_lane_s32(M[k], 1)); break;
					case 2: printf("%.2d ", vgetq_lane_s32(M[k], 2)); break;
					case 3: printf("%.2d ", vgetq_lane_s32(M[k], 3)); break;
				}
			}
			printf("\n");
		}
		printf("\n");
	}
    //transpose_32x4(M);
    //for (i = 0; i < 4; i++) {
      //  for (j = 0; j < 4; j++) {
        //    switch(j) {
	//	case 0: printf("%.2d ", vgetq_lane_s32(M[i], 0)); break;
	//	case 1: printf("%.2d ", vgetq_lane_s32(M[i], 1)); break;
	//	case 2: printf("%.2d ", vgetq_lane_s32(M[i], 2)); break;
	//	case 3: printf("%.2d ", vgetq_lane_s32(M[i], 3)); break;
        //  	}
     //   }
       // printf("\n");
   // }
    // printf("\n");

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
