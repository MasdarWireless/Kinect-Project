% Mixture of two normals
x = [randn(30,1); 5+randn(30,1)];
subplot(211);
hist(x); title('Histogram of Raw Data');
[f,xi] = ksdensity(x); %pdf estimate
subplot(212)
plot(xi,f); title('PDF');