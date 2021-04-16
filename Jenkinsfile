pipeline {
  agent any

  stages {

    stage("build") {
      steps{
        echo 'preparing the env'
        sh 'python3 -m venv .env'
        sh """
        . .env/bin/activate
        pip install flake8 pytest
        pip install -r requirements.txt
        """
      }
    }

    stage("test") {
      steps{
        echo 'testing the app'
        sh """
        . .env/bin/activate
        flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
        flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
        pytest -v
        """
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
