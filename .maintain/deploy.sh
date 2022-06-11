git pull

# zh
git checkout main
bundle exec jekyll build
rm -rf _deploy
mkdir _deploy
cp -rf _site _deploy/zh

#en
# git checkout lang-en
# bundle exec jekyll build
# rm -rf _deploy
# mkdir _deploy
# cp -rf _site _deploy/en
