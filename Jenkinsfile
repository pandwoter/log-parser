pipeline {
  agent { docker { image 'ruby:2.7.1' } }
  stages {
    stage('dependencies') {
      steps {
        sh 'gem install bundler -v 2.0.1'
      }
    }
    stage('build') {
      steps {
        sh 'bundle install'
      }
    }
    stage('test') {
      steps {
        sh 'rspec'
      }
    }
  }
}
