pipeline {
  agent {
    docker 'python:3.8.6'
  }

  stages {

    stage("build") {
      steps{
        echo 'preparing the env'
        sh 'sudo pip install flake8 pytest --user'
        sh 'sudo pip install -r requirements.txt --user'
      }
    }

    stage("test") {
      steps{
        echo 'testing the app'
      }
    }

    stage("push") {
      steps{
        echo 'pushing the app'
      }
    }

    stage("deploy") {
      steps{
        echo 'deploying the app'
      }
    }

  }
}
