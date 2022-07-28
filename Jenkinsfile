#!/usr/bin/env groovy

def gemfiles = [
    'rails-5.2.gemfile',
    'rails-6.0.gemfile',
    'rails-6.1.gemfile',
]
def buildMatrix = gemfiles.collectEntries { gemfile ->
    ['2.6', '2.7', '3.0', '3.1'].collectEntries { ruby ->
        ["Ruby ${ruby} - ${gemfile}": {
            sh """
                docker-compose run -e BUNDLE_GEMFILE="spec/gemfiles/${gemfile}" \
                    --name "${env.JOB_NAME.replaceAll("/", "-")}-${env.BUILD_ID}-ruby-${ruby}-${gemfile}-rspec" \
                    app /bin/bash -lc "rvm-exec ${ruby} bundle install --jobs 3 && rvm-exec ${ruby} bundle exec rspec"
            """
        }]
    }
}
// buildMatrix = buildMatrix.findAll { it.key != 'Ruby 3.0 - rails-5.2.gemfile' }
buildMatrix << ['Lint': {
    sh 'docker-compose run --rm app /bin/bash -lc "rvm-exec 2.7 bundle exec rubocop --fail-level autocorrect"'
}]

pipeline {
    agent {
        label 'docker'
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '50'))
        timeout(time: 20, unit: 'MINUTES')
    }
    stages {
        stage('Build') {
            steps {
                sh 'docker-compose build --pull'
                // Initialize docker network now to avoid race condition later.
                sh 'docker-compose run --rm app /bin/bash -lc "rvm version"'
            }
        }
        stage('Test') {
            steps { script { parallel buildMatrix } }
            post {
                always {
                    sh "docker cp \"${env.JOB_NAME.replaceAll("/", "-")}-${env.BUILD_ID}-ruby-2.7-rails-6.1.gemfile-rspec:/app/coverage\" ."
                    archiveArtifacts artifacts: 'coverage/*.json', fingerprint: true
                }
            }
        }
        stage('Deploy') {
            when {
                allOf {
                    expression { GERRIT_BRANCH == "master" }
                    environment name: "GERRIT_EVENT_TYPE", value: "change-merged"
                }
            }
            steps {
                lock( // only one build enters the lock
                resource: "${env.JOB_NAME}" // use the job name as lock resource to make the mutual exclusion only for builds from the same branch/tag
                ) {
                    withCredentials([string(credentialsId: 'rubygems-rw', variable: 'GEM_HOST_API_KEY')]) {
                        sh 'docker-compose run  -e GEM_HOST_API_KEY --rm app /bin/bash -lc "./bin/publish.sh"'
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                sh 'docker-compose down --remove-orphans --rmi all'
            }
        }
    }
}
