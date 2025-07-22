#include <stdio.h>
#include <stddef.h>
#include <arm_neon.h>

FILE* f;
int32x4_t a = {1, 2, 3, 4};
int32x4_t b = {5, 6, 7, 8};
int32x4_t c = {9, 10, 11, 12};
int32x4_t d = {13, 14, 15, 16};

int main() {
    // f = fopen("matrix.txt", "r");
    // if ((f == NULL)) {
    //     printf("Error reading file\n");
    //     fclose(f);
    //     return 1;
    // }
    // fclose(f);
    int32x4_t matrix[4] = {a, b, c, d};
    int i;
    int j;
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 4; j++) {
            printf("%.2d ", vgetq_lane_s32(matrix[i], j));
        }
        printf("\n");
    }
    printf("\n");
    int32x4x2_t temp;
    temp = vtrnq_s32(a, b);
    matrix[0] = temp.val[0];
    matrix[1] = temp.val[1];
    temp = vtrnq_s32(c, d);
    matrix[2] = temp.val[0];
    matrix[3] = temp.val[1];
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 4; j++) {
            printf("%.2d ", vgetq_lane_s32(matrix[i], j));
        }
        printf("\n");
    }
    printf("\n");
    int32x2_t ah = vget_high_s32(matrix[0]);
    int32x2_t al = vget_low_s32(matrix[0]);
    int32x2_t bh = vget_high_s32(matrix[1]);
    int32x2_t bl = vget_low_s32(matrix[1]);
    int32x2_t ch = vget_high_s32(matrix[2]);
    int32x2_t cl = vget_low_s32(matrix[2]);
    int32x2_t dh = vget_high_s32(matrix[3]);
    int32x2_t dl = vget_low_s32(matrix[3]);
    int32x4_t aa = vcombine_s32(al, cl);
    int32x4_t bb = vcombine_s32(bl, dl);
    int32x4_t cc = vcombine_s32(ah, ch);
    int32x4_t dd = vcombine_s32(bh, dh);
    matrix[0] = aa;
    matrix[1] = bb;
    matrix[2] = cc;
    matrix[3] = dd;

    for (i = 0; i < 4; i++) {
        for (j = 0; j < 4; j++) {
            printf("%.2d ", vgetq_lane_s32(matrix[i], j));
        }
        printf("\n");
    }
    printf("\n");
    return 0;
}
