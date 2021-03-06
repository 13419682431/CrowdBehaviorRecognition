trainingFolder = '../data/images/categorized';
testingFolder = '../data/images/sampleImages';
imgSets = [ imageSet(fullfile(trainingFolder, 'activity_density/idle')), ...
            imageSet(fullfile(trainingFolder, 'activity_density/sparse')), ...
            imageSet(fullfile(trainingFolder, 'activity_density/cheering'))];

{ imgSets.Description } % display all labels on one line
[imgSets.Count]         % show the corresponding count of images

minSetCount = min([imgSets.Count]); % determine the smallest amount of images in a category

% Use partition method to trim the set.
imgSets = partition(imgSets, minSetCount, 'randomize');

% Notice that each set now has exactly the same number of images.
[imgSets.Count]

[trainingSets, validationSets] = partition(imgSets, 0.3, 'randomize');

idle     = read(trainingSets(1),1);
sparse   = read(trainingSets(2),1);
cheering = read(trainingSets(3),1);


figure

subplot(1,3,1);
imshow(idle)
subplot(1,3,2);
imshow(sparse)
subplot(1,3,3);
imshow(cheering);

bag = bagOfFeatures(trainingSets);

img = read(imgSets(1), 1);
featureVector = encode(bag, img);

categoryClassifier = trainImageCategoryClassifier(trainingSets, bag);

%confMatrix = evaluate(categoryClassifier, trainingSets);

confMatrix = evaluate(categoryClassifier, validationSets);

% Compute average accuracy
mean(diag(confMatrix));

img = imread(fullfile(testingFolder, '001.jpg'));
[labelIdx, scores] = predict(categoryClassifier, img);

% Display the string label
categoryClassifier.Labels(labelIdx)
