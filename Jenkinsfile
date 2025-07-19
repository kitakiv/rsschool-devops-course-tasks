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
    stage('Test') {
      agent{
        kubernetes {
          yamlFile './jenkins-pods/python-pod.yaml'
        }
      }
      steps {
        container('python'){
          sh '''
            python --version
            pip --version
            cd python_app
            pip install -r requirements.txt
            pytest test.py
          '''
        }
      }
    }
    stage('SonarQube Analysis') {
      agent{
        kubernetes {
          yamlFile './jenkins-pods/sonarqube-pod.yaml'
        }
      }
      steps {
        container('sonar-scanner') {
          withSonarQubeEnv('sonar_qube') {
            sh 'sonar-scanner'
          }
        }
      }
    }
  }
}
