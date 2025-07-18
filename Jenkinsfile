pipeline {
  agent none
  stages {
    stage('Build') {
      agent{
        kubernetes {
          yamlFile './jenkins-pods/python-pod.yaml'
        }
      }
      steps {
        checkout scm

        container('python'){
          sh '''
            python --version
            cd python_app
            pip install -r requirements.txt
            cd ..
          '''
        }
      }
    }
  }
}