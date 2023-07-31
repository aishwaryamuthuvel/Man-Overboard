# Man-Overboard

The Man Overboard project is aimed at tracking the test buoy in the video given the initial position and then estimating its distance from the camera in meters. The algorithm proposed involves computing a motion model for the movement of the buoy. Using the motion model an ROI is defined on each video frame. This ROI is expected to contain the buoy’s location within it. The ROI is then thresholded to help separate the buoy from its background and calculate its exact position. Then we used the difference in angle between consecutive buoy positions along with a spherical model for Earth to compute the distance of the buoy from the camera. For the first video frame, when the previous buoy location is not known, the angle between the buoy and the horizon was used for calculations.

The Man Overboard project is an attempt to use Image Processing and Computer Vision techniques to find a person lost in the sea – ‘Man Overboard’ and to track and estimate the distance of the person's location from the vessel to help and plan the rescue operations. 

A detailed report on the method could be found [here](https://github.com/aishwaryamuthuvel/Man-Overboard/blob/main/Man%20Overboard%20group%2018.pdf).




