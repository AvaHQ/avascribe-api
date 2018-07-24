sbranch=$1
tmpDir=/tmp/avadts_`date +%s`
mkdir $tmpDir
`aws ecr get-login --no-include-email --region us-west-2`
url="132710680715.dkr.ecr.us-west-2.amazonaws.com/dtsgenerator"
docker pull $url:latest
docker run -v $tmpDir:/tmp -v `pwd`/schemas:/schemas $url:latest
cp -r schemas $tmpDir/schemas

rm -rf *
commithash=`git rev-parse HEAD`
branch=`git rev-parse --abbrev-ref HEAD`
git fetch origin dts-$sbranch
git branch -D dts-$sbranch
git checkout dts-master
git checkout -b dts-$sbranch --force
git reset --hard origin/dts-$sbranch
mv $tmpDir ./package
aws s3 cp --recursive package s3://ava-ci/node/packages/avascribe-api/$sbranch:$commithash
aws s3 cp --recursive s3://ava-ci/node/packages/avascribe-api/$sbranch:$commithash s3://ava-ci/node/packages/avascribe-api/$sbranch:latest
mv package/* .
rm -rf package
git add schemas index.d.ts
git commit -am "[automatic] update types from $branch:$commithash"
git push origin dts-$sbranch
rm -rf *
git checkout $sbranch
git reset --hard $commithash
