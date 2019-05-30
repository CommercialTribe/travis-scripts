set -e

echo "Starting Assessment End-To-End Tests"
echo "Images:"
echo " assessment-e2e: ${IMAGE_E2E}"
echo " assessment-frontend: ${IMAGE_ASSESSMENT_FRONTEND}"
echo " assessment-api: ${IMAGE_ASSESSMENT_API}"

# TODO Replace with latest image
imageAssessmentApiLatest="${DOCKER_BASE_IMAGE_PATH}/assessment-api:feature-e2e"

authHeader="Authorization: token ${GITHUB_API_TOKEN}"
acceptHeader='Accept: application/vnd.github.v3.raw'
githubUrlPrefix=https://api.github.com/repos/CommercialTribe
dockerComposeFile=docker-compose-e2e.yml

echo "Getting ${dockerComposeFile}"
dockerComposeE2e="${githubUrlPrefix}/assessment-e2e/contents/docker-compose-e2e.yml"
curl -H "${authHeader}" -H "${acceptHeader}" -sSL ${dockerComposeE2e} > ${dockerComposeFile}

echo "Getting assessment-api .env.docker"
assessmentApiEnv="${githubUrlPrefix}/assessment-api/contents/.env.docker"
curl -H "${authHeader}" -H "${acceptHeader}" -sSL ${assessmentApiEnv} > assessment-api.env

echo "Bootstrapping db"
IMAGE_ASSESSMENT_API=${imageAssessmentApiLatest} docker-compose -f ${dockerComposeFile} run assessment-api yarn db:bootstrap

echo "Running e2e tests"
docker-compose -f ${dockerComposeFile} run e2e
