# subspace-clustering in the '/gitlocal' folder

Experimental code for comparing our new algorithm for subspace clustering---'NLRR++' with other existing methods. 

1. Subspace clustering methods are organized in folders '~/ORPCA, ~/OLRSC, ~/LRR, ~/SSC, ~/NLRRSS'

2. NLRR ('NLRR.m', 'NLRRE.m') and NLRR++ ('NLRRplus.m', 'NLRRplusE.m') functions are displayed in the folder'~/NLRRSS'. 

3. Code for running experiments are named as 'test**.m' which can be executed directly. 

4. Datasets: 'Imagenet'(features trained by CNN), 'MNIST', 'SVHN', 'USPS', 'Protein'. 

5. Clustering baseline and evaluation metric function are in the '~/clusterings' folder. 

6. Competing methods:

(1) NLRR:Jie Shen and Ping Li. 2016. Learning structured low-rank representation via matrix factorization. In Proceedings of the 19th International Conference on Articial Intelligence and Statistics (ICAIS). 500–509

(2) OLRSC:Jie Shen, Ping Li, and Huan Xu. 2016. Online Low-Rank Subspace Clustering by
Basis Dictionary Pursuit. In Proceedings of the 33rd International Conference on Machine Learning (ICML). 622–631

(3) LRR: Guangcan Liu, Zhouchen Lin, and Yong Yu. 2010. Robust subspace segmentation by low-rank representation. In Proceedings of the 27th international conference on machine learning (ICML). 663–670.

(4) SSC:Ehsan Elhamifar and Rene Vidal. 2013. Sparse subspace clustering: Algorithm, theory, and applications. IEEE transactions on paern analysis and machine intelligence 35, 11 (2013), 2765–2781.

(5) ORPCA:Jiashi Feng, Huan Xu, and Shuicheng Yan. 2013. Online robust pca via stochastic optimization. In Advances in Neural Information Processing Systems. 404–412
