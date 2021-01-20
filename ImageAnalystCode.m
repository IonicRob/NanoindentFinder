%% Image Analyst Function
% Based off https://uk.mathworks.com/matlabcentral/answers/55253-how-to-crop-an-image-automatically#answer_67074
function [ImageAfter_out,ImageBefore_out] = ImageAnalystCode(ImageAfter,ImageBefore)
    % Get all rows and columns where the image is nonzero
    [nonZeroRows, nonZeroColumns] = find(ImageAfter);
    % Get the cropping parameters
    topRow = min(nonZeroRows(:));
    bottomRow = max(nonZeroRows(:));
    leftColumn = min(nonZeroColumns(:));
    rightColumn = max(nonZeroColumns(:));
    % Extract a cropped image from the original.
    ImageAfter_out = ImageAfter(topRow:bottomRow, leftColumn:rightColumn);
    ImageBefore_out = ImageBefore(topRow:bottomRow, leftColumn:rightColumn);
end