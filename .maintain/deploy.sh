# git pull

# mkdir -p _deploy
# rm -rf _deploy/*

# #en
# git checkout lang-en
# bundle exec jekyll build
cp -rf _site _deploy/en

# zh-cn
git checkout main
bundle exec jekyll build
cp -rf _site _deploy/zh-cn

# zh-tw
git checkout lang-zh-tw
bundle exec jekyll build
cp -rf _site _deploy/zh-tw

# kr
git checkout lang-kr
bundle exec jekyll build
cp -rf _site _deploy/kr

# jp
git checkout lang-jp
bundle exec jekyll build
cp -rf _site _deploy/jp

# copy index.html
cp .maintain/index.html _deploy/

# Checkout to main
git checkout main
