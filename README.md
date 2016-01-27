Summary:

Edge detection of noisy images requires smoothing filters which finely balance denoising and retaining the strength of the edges. Hence, various smoothing filters are studied in the viewpoint of edge detection too. Many denoising filters have been studied and implemented so far. BM3D Filter (which stands for Block Matching 3D filtering) happens to be the state-of-the-art in the field of image smoothing. It overcomes some of the shortcomings of other denoising filters when large amount of noise is involved.

What we have done here?

Implemented various denoising filters prior to edge detection to enhance the quality of edge deetection. Apart from the standard Gaussian filter, Median, Bilateral and BM3D have been used separately to remove the noise (AWGN) which was earlier added to the image. After denoising, Canny, Prewitt, Sobel and Robert operators have been employed for robust edge detection.
