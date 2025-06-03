pipeline {
  agent any

  environment {
    AWS_REGION = 'ap-southeast-1'
    ECR_REGISTRY = '547694239239.dkr.ecr.ap-southeast-1.amazonaws.com'
    ECR_REPO = 'caringup_demo'
    IMAGE_TAG = 'latest'
    CLUSTER_NAME = 'demo-eks'
  }

  stages {
    stage('Clone Repository') {
      steps {
        git 'https://github.com/VMoshik/my-static-site.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $ECR_REPO:$IMAGE_TAG ./my-static-site'
      }
    }

    stage('Push to ECR') {
      steps {
        sh '''
        aws ecr get-login-password --region $AWS_REGION | \
        docker login --username AWS --password-stdin $ECR_REGISTRY

        docker tag $ECR_REPO:$IMAGE_TAG $ECR_REGISTRY/$ECR_REPO:$IMAGE_TAG
        docker push $ECR_REGISTRY/$ECR_REPO:$IMAGE_TAG
        '''
      }
    }

    stage('Deploy to EKS') {
      steps {
        dir('my-static-site') {
          sh '''
          aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
          kubectl apply -f deployment.yaml
          kubectl apply -f service.yaml
          '''
        }
      }
    }
  }

  post {
    success {
      echo '✅ Deployment successful!'
    }
    failure {
      echo '❌ Deployment failed!'
    }
  }
}
