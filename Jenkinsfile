def terraformExamplesBadge = addEmbeddableBadgeConfiguration(id: "terraformExamplesBuild", subject: "Terraform examples build")

pipeline {
    agent { dockerfile true }
    stages {
    stage('terraform validate') {
      steps { 
        script {
          try {
            terraformExamplesBadge.setStatus('running')
            sh 'make lint-terraform' 
          } catch (Exception err) {
            terraformExamplesBadge.setStatus('failing')
            error 'Build failed'
          }
        }
      }
    }
    stage('rstcheck') {
      steps { 
        script {
          try {
            sh 'make lint-rst'
            terraformExamplesBadge.setStatus('passing')
          } catch (Exception err) {
            terraformExamplesBadge.setStatus('failing')
            error 'Build failed'
          }
        }
      }
    }
  }
}
