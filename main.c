#include <stdio.h>
#include <stddef.h>
#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>

FILE* f;
// Matrix M
int32x4_t m_1 = {0,0,0,0};
int32x4_t m_2 = {0,0,0,0};
int32x4_t m_3 = {0,0,0,0};
int32x4_t m_4 = {0,0,0,0};

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
#define ANGLE_45    16384
#define ANGLE_90    32768

// Structure to hold sin and cos values
typedef struct {
    int16_t angle_deg;
    int16_t sin_q15;
    int16_t cos_q15;
} TrigPair;

// Lookup table: angles around 0, 45, and 90 degrees
TrigPair trig_table[] = {
    { 0,    0,     32768 },     // sin(0°), cos(0°)
    { 22,   12288, 30199 },     // sin(22°), cos(22°)
    { 45,   23170, 23170 },     // sin(45°), cos(45°)
    { 67,   30199, 12288 },     // sin(67°), cos(67°)
    { 90,   32768,     0 }      // sin(90°), cos(90°)
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

int32_t arctan(int32_t val) {
    return 0;
}

int32_t cos_t(int32_t theta) {
    return 0;
}

int32_t sin_t(int32_t theta) {
    return 0;
}

void get_rotatation(int32x2_t* R, int32_t theta) {
    vset_lane_32(cos_t(theta), R[0], 0);
    vset_lane_32(-sin_t(theta), R[0], 1);
    vset_lane_32(sin_t(theta), R[1], 0);
    vset_lane_32(cos_t(theta), R[1], 1);
}

void transpose_32x2(int32x2_t* M) {
    int32x2x2_t temp;
    temp = vtrn_s32(M[0], M[1]);
    M[0] = temp.val[0];
    M[1] = temp.val[1];
}

void rotate(int32x2_t* M) {
    int sum = (vget_lane_s32(M[1], 0) + vget_lane_s32(M[0], 1)) / (vget_lane_s32(M[1], 1) - vget_lane_s32(M[0], 0));
    int dif = (vget_lane_s32(M[1], 0) - vget_lane_s32(M[0], 1)) / (vget_lane_s32(M[1], 1) + vget_lane_s32(M[0], 0));
    sum = arctan(sum);
    dif = arctan(dif);
    int theta_r = (sum + dif) >> 2;
    int theta_l = sum - theta_r;
    int32x2_t R_L[2] = { {}, {} };
    int32x2_t R_R[2] = { {}, {} };
    get_rotatation(R_L, theta_l);
    get_rotatation(R_R, theta_r);
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
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 4; j++) {
            printf("%.2d ", vgetq_lane_s32(M[i], j));
        }
        printf("\n");
    }
    printf("\n");
    // int32x4x2_t temp;
    // temp = vtrnq_s32(M[0], M[1]);
    // M[0] = temp.val[0];
    // M[1] = temp.val[1];
    // temp = vtrnq_s32(M[2], M[3]);
    // M[2] = temp.val[0];
    // M[3] = temp.val[1];
    // for (i = 0; i < 4; i++) {
    //     for (j = 0; j < 4; j++) {
    //         printf("%.2d ", vgetq_lane_s32(M[i], j));
    //     }
    //     printf("\n");
    // }
    // printf("\n");
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
    transpose_32x4(M);
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 4; j++) {
            printf("%.2d ", vgetq_lane_s32(M[i], j));
        }
        printf("\n");
    }
    printf("\n");

    int16_t test_angles[] = {1000, 14000, 16000, 30000};
    for (i = 0; i < 4; i++) {
        AngleCategory cat = categorize_angle(test_angles[i]);
        printf("Angle %d categorized as %d\n", test_angles[i], cat);
        set_rotation(cat);
        printf("Angle: %d, Sin: %d, Cos: %d\n", trig_table[cat].angle_deg, trig_table[cat].sin_q15, trig_table[cat].cos_q15);
    }
    return 0;
}
