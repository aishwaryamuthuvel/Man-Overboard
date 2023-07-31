# Man-Overboard

The Man Overboard project is aimed at tracking the test buoy in the video given the initial position and then estimating its distance from the camera in meters. The algorithm proposed involves computing a motion model for the movement of the buoy. Using the motion model an ROI is defined on each video frame. This ROI is expected to contain the buoy’s location within it. The ROI is then thresholded to help separate the buoy from its background and calculate its exact position. Then we used the difference in angle between consecutive buoy positions along with a spherical model for Earth to compute the distance of the buoy from the camera. For the first video frame, when the previous buoy location is not known, the angle between the buoy and the horizon was used for calculations.

The Man Overboard project is an attempt to use Image Processing and Computer Vision techniques to find a person lost in the sea – ‘Man Overboard’ and to track and estimate the distance of the person's location from the vessel to help and plan the rescue operations. 

A detailed report on the method could be found [here](https://github.com/aishwaryamuthuvel/Man-Overboard/blob/main/Man%20Overboard%20group%2018.pdf).

## Materials

As input, we have a video of a test buoy in a wavy sea environment and the initial location of the buoy. 
To help with the distance estimation aspect of the problem statement, we are given the height of the camera from the sea level during the recording and camera calibration images from which the intrinsic parameters of the camera could be obtained.

The algorithm was developed in MATLAB. 

## Method
The aims of the project are to locate the buoy in each image frame of the input video and to estimate the distance of the buoy from the camera.
The input is an RGB video with 432 frames and each of the dimensions 1080x1440. On seeing the input video, we can sense unwanted camera motions during the recording process and hence as a preprocessing step, we stabilize the input video. The preprocessed video was then used to estimate a motion model for the buoy. For this, we used the optic flow computed using the Farneback method. Using the motion model and the initial position of the buoy we were able to successfully define an ROI of size 100 x 50 that enclosed the buoy. In order to locate the buoy within the ROI, the ROI was thresholded. This separated the buoy from its background and the centroid gave the exact location of the buoy. 

For the second part of the aim, calculating the distance of the buoy from the camera, we first obtained the intrinsic parameters of the camera. This was done using the Camera Calibrator app of the Computer Vision toolbox in MATLAB. Using the intrinsic matrix of the camera, the location of each pixel in the camera coordinates could be obtained. These were further used to obtain the angles that they made with the principal axis of the camera. These angles are then combined with the spherical model of Earth to arrive at the distance of the buoy from the camera.

Below is a flowchart with the algorithm steps. 

<p align="center">
<img src="https://github.com/aishwaryamuthuvel/Man-Overboard/blob/main/Images/flowchat.png" width=85% height=75% />
</p>


### Video Stabilization
The input video was stabilized to remove unwanted camera motions that were captured during the recording process. We used an existing video stabilizing algorithm provided by MathWorks which tracks a target area and identifies how much the target area has moved with respect to the previous frame. Using this information, the algorithm transforms each of the image frames in the video to remove unwanted camera motions and to generate a stabilized video. 

Below is the input image with the target area that was chosen for tracking for video stabilization and the output stabilized image.
<p align="center">
<img src="https://github.com/aishwaryamuthuvel/Man-Overboard/blob/main/Images/videostabilization.png" width=85% height=75% />
</p>

### Motion Model Estimation

The aim is to determine the velocities in both x and y directions for the buoy in terms of pixels/frame. For this, we use the optic flow velocity vectors calculated using the Farneback algorithm. Due to the small size of the buoy, we needed to use dense optical flow estimating algorithms. The Farneback algorithm is a dense optical flow algorithm. The Farneback method is a two-frame motion estimation algorithm that uses quadratic polynomials to approximate the motion between the frames and also uses polynomial expansion to accommodate the neighbours of the pixel. 

A motion model was built using the Farneback algorithm and using it we were able to track the buoy with an ROI of size 100x50. 

### Detecting the Exact Location of the Buoy

On thresholding the ROI with a threshold of 0.7 we were able to separate the buoy from its background but the problem with this method was that the foam or the air bubbles on the sea waves were also white and had intensities close to 1. So in frames where the ROI contained the buoy along with foam, we got more than one white region in the thresholded image of the ROI. To overcome this problem, we computed the centroids of all the white regions and considered the centroid distance from the previous buoy location to filter out the unwanted regions.

### Estimating the Distance of the Buoy from the Camera

In this section, we used the height of the camera from the sea level – 2.5m, the spherical model of Earth and the buoy position in the image frames of the video to estimate the distance of the buoy from the camera.
	
For the first frame with the buoy, we use the pixel location of the horizon and the buoy location to compute the distance. The horizon spans from left to right of the image but we need to select one pixel location for our calculations. For this, we calculated the horizon pixel that was in line with the buoy location and the principal points. 

### Results

The ROI at all times encloses the region within which the algorithm searches for the buoy (even when it is not seen in the video frame) and the red circle appears around the buoy whenever it is found. The distance starts at 120.9m and reduces to 62.3m. Below is a sample video frame with the ROI in yellow, the buoy detected in red and the corresponding estimated distance.

<p align="center">
<img src="https://github.com/aishwaryamuthuvel/Man-Overboard/blob/main/Images/Output.png" width=85% height=75% />
</p>












