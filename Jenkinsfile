pipeline {
    agent { dockerfile true }
    stages {
    stage('terraform validate') {
      steps { sh 'make lint-terraform' }
    }
    stage('rstcheck') {
      steps { sh 'make lint-rst' }
    }
  }
}
