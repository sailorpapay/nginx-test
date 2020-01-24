pipeline {  environment {
    registry = "sailorpapay/nginx-test/"
    registryCredential = 'dockerhub'
  }  agent any  stages {
    stage('Building image') {
      steps{
        script {
          docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
  }
}
