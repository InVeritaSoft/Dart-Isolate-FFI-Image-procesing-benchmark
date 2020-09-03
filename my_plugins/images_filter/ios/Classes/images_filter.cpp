//#include <stdint.h>
#include <math.h>
//#include <stdlib.h>
#include <stdio.h>
#include <cstdlib>
//#include <stdarg.h>


extern "C" __attribute__((visibility("default"))) __attribute__((used))
int32_t native_add(int32_t x, int32_t y) {
    return x + y;
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int* getArray(int *arr){
    return arr;
}

int* _normalizeKernel(int* kernel,int kernel_length ) {
  int sum = 0;
  for (int i = 0; i < kernel_length; i++) {
    sum += kernel[i];
  }
  if (sum != 0 && sum != 1) {
    for (int i = 0; i < kernel_length; i++) {
      kernel[i] /= sum;
    }
  }
  return kernel;
}

int _clampPixel(int x){
    if(x < 0)
        return 0;
    if(x > 255)
        return 255;
    return x;
};

void convolute( int* pixels,int pixels_lenght, int width, int height,
                int* weights,int weights_length,float bias) {
  //var bytes = Uint8List.fromList(pixels);
  int side = round(sqrt((double)weights_length));
  int halfSide = round((double)(~~(side / 2))) - side % 2;
  int sw = width;
  int sh = height;

  int w = sw;
  int h = sh;

  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      int sy = y;
      int sx = x;
      int dstOff = (y * w + x) * 4;
      int r = bias, g = bias, b = bias;
      for (int cy = 0; cy < side; cy++) {
        for (int cx = 0; cx < side; cx++) {
          int scy = sy + cy - halfSide;
          int scx = sx + cx - halfSide;

          if (scy >= 0 && scy < sh && scx >= 0 && scx < sw) {
            int srcOff = (scy * sw + scx) * 4;
            float wt = weights[cy * side + cx];

            r += pixels[srcOff] * wt;
            g += pixels[srcOff + 1] * wt;
            b += pixels[srcOff + 2] * wt;
          }
        }
      }
      pixels[dstOff] = _clampPixel(round((double)r));
      pixels[dstOff + 1] = _clampPixel(round((double)g));
      pixels[dstOff + 2] = _clampPixel(round((double)b));
    }
  }
}


// Convolute - weights are 3x3 matrix
uint8_t * convolute1(uint8_t * pixels,int pixels_lenght, int width, int height,
                     int8_t* weights,int weights_length, float bias
                ) {
  uint8_t bytes[pixels_lenght];
  for (int i = 0; i < pixels_lenght; i++) {
      bytes[i] = pixels[i];
  }
    
  int side = round(sqrt((double)weights_length));
  int halfSide = roundf((float)(~~(side / 2))) - side % 2;
  int sw = width;
  int sh = height;

  int w = sw;
  int h = sh;

  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      int sy = y;
      int sx = x;
      int dstOff = (y * w + x) * 4;
      float r = bias, g = bias, b = bias;
      for (int cy = 0; cy < side; cy++) {
        for (int cx = 0; cx < side; cx++) {
          int scy = sy + cy - halfSide;
          int scx = sx + cx - halfSide;

          if (scy >= 0 && scy < sh && scx >= 0 && scx < sw) {
            int srcOff = (scy * sw + scx) * 4;
            float wt = weights[cy * side + cx];

            r += bytes[srcOff] * wt;
            g += bytes[srcOff + 1] * wt;
            b += bytes[srcOff + 2] * wt;
          }
        }
      }
      pixels[dstOff] = _clampPixel(round(r));
      pixels[dstOff + 1] = _clampPixel(round(g));
      pixels[dstOff + 2] = _clampPixel(round(b));
    }
  }
  return pixels;
}


extern "C" __attribute__((visibility("default"))) __attribute__((used))
uint8_t* applyImageFilter(uint8_t* pixels,int pixels_lenght, int width, int height,
                      int8_t* weights,int weights_length,float bias){
    //printf("3 + 5 = %d\n", 3 + 5);

    return  convolute1(
             pixels,
             pixels_lenght,
             width,
             height,
             //_normalizeKernel(weights,weights_length),
             weights,
             weights_length,
             bias
    );
   
}



