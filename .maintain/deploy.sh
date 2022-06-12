mkdir -p _deploy
rm -rf _deploy/*

#en
git checkout lang-en
git pull
bundle exec jekyll build
cp -rf _site _deploy/en

# zh-cn
git checkout main
git pull
bundle exec jekyll build
cp -rf _site _deploy/zh-cn

# zh-tw
git checkout lang-zh-tw
git pull
bundle exec jekyll build
cp -rf _site _deploy/zh-tw

# kr
git checkout lang-kr
git pull
bundle exec jekyll build
cp -rf _site _deploy/kr

# jp
git checkout lang-jp
git pull
bundle exec jekyll build
cp -rf _site _deploy/jp

# copy index.html
cp .maintain/index.html _deploy/

# Checkout to main
git checkout main
