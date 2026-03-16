#!/bin/bash
# 누수체크 - WSL2 환경 초기 셋업 스크립트
# 사용법: bash bin/wsl_setup.sh

set -e

echo "=== 누수체크 WSL2 환경 셋업 ==="

# 1. 시스템 업데이트
echo "시스템 패키지 업데이트..."
sudo apt update && sudo apt upgrade -y

# 2. 필수 패키지 설치
echo "필수 패키지 설치..."
sudo apt install -y build-essential git curl libssl-dev libreadline-dev \
  zlib1g-dev autoconf bison libyaml-dev libncurses5-dev libffi-dev \
  libgdbm-dev libpq-dev imagemagick libvips

# 3. mise (Ruby/Node.js 버전 관리자) 설치
if ! command -v mise &> /dev/null; then
  echo "mise 설치..."
  curl https://mise.run | sh
  echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
  eval "$(~/.local/bin/mise activate bash)"
fi

# 4. Ruby 설치
echo "Ruby 3.3 설치..."
mise use --global ruby@3.3

# 5. Node.js 설치
echo "Node.js 20 설치..."
mise use --global node@20
npm install -g yarn

# 6. PostgreSQL 설치
echo "PostgreSQL 설치..."
sudo apt install -y postgresql postgresql-contrib libpq-dev
sudo service postgresql start
sudo -u postgres createuser -s $(whoami) 2>/dev/null || echo "PostgreSQL 사용자 이미 존재"

# 7. Redis 설치
echo "Redis 설치..."
sudo apt install -y redis-server
sudo service redis-server start

# 8. Rails + Bundle
echo "Rails 설치..."
gem install rails -v '~> 7.1'
gem install bundler

echo ""
echo "=== 환경 셋업 완료! ==="
echo ""
echo "다음 단계:"
echo "  1. cd ~/projects/nusucheck  (또는 프로젝트를 WSL 내부로 복사)"
echo "  2. bundle install"
echo "  3. bin/rails db:create"
echo "  4. bin/rails db:migrate"
echo "  5. bin/rails db:seed"
echo "  6. bin/rails server"
echo ""
echo "브라우저에서 http://localhost:3000 접속"
