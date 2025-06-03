pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = '547694239239'
        AWS_REGION = 'ap-southeast-1'
        ECR_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/caringup_demo"
        IMAGE_TAG = 'latest'  // you can make this dynamic if needed
        EKS_CLUSTER_NAME = 'your-eks-cluster-name'  // Replace with your actual EKS cluster name
    }

    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${ECR_REPO}:${IMAGE_TAG} .'
            }
        }
        
        stage('Login to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region ${AWS_REGION} | \
                docker login --username AWS --password-stdin ${ECR_REPO}
                '''
            }
        }
        
        stage('Push Docker Image') {
            steps {
                sh 'docker push ${ECR_REPO}:${IMAGE_TAG}'
            }
        }

        stage('Configure kubectl') {
            steps {
                sh 'aws eks --region ${AWS_REGION} update-kubeconfig --name ${demo-eks}'
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
            }
        }
    }
}
