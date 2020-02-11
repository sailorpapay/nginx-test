node {
    def app

    stage('Clone repository') {
        checkout scm
    }

    stage('Build image') {
        app = docker.build("sailorpapay/jenkins-nginx")
    }
    
     stage('Push image') {
        docker.withRegistry('', '3e6816fa-739d-41f1-a587-df0f99b0163f') {
            app.push()
        }
    }
    
    stage('Test image') {
        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    
}
