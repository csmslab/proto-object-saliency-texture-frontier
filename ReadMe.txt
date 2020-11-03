Proto-Object Based Visual Saliency Model with Texture Detection Channels(MATLAB code)

Takeshi Uejima, uejima.takeshi@gmail.com / tuejima1@jhu.edu
Johns Hopkins University

This model is based on Russell et al. model but modified to incorporate texture channels.
The detail is written in T. Uejima, E. Niebur, and R. Etienne-Cummings. "Proto-Object Based Saliency Model With Texture Detection Channel", Frontiers in Computational Neuroscience.

===============================================================================
How to Use

(1) Add the folder of "ProtoObjectSaliencyTextureFrontiers" and its subfolders to your MATLAB path.
(2) Run "result=runProtoSalTexMax('filename','ICOR')"
    The first argue is the input file name.
    The second argue is the channels to use for calculating saliency.
      I: Intensity, C: Color, O: Orientation, R: Texture.
      A: Cross-Scale Energy Texture, B:Cross-Orientation Energy Texture, F: Spatial-Pooling Texture,
      S: Color Cross-Scale Energy Texture, T: Color Cross-Orientation Energy, V: Color Spatial-Pooling Texture
    The output is a structure and its "data" field is the predicted saliency.
*"runProtoSalTexMaxCAT2000" is a modified code to process the images of CAT2000. This code remove the gray margins of the images before feeding them to the algorithm.
 This is how we have processed the CAT2000 images in the paper of Frontiers in Computational Neuroscience.

===============================================================================
References

1. Uejima, T., Niebur, E., and Etienne-Cummings, R. (2020). Proto-Object Based Saliency Model With Texture Detection Channel. Front. Comput. Neurosci. 14, 84.
2. Russell, A. F., Mihalaş, S., von der Heydt, R., Niebur, E., and Etienne-Cummings, R. (2014). A model of proto-object based saliency. Vision Res. 94, 1–15.