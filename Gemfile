# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.5.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rubocop-performance'
gem 'parslet'

gem 'pry'
gem 'pry-byebug'
gem 'byebug', platforms: %i[mri mingw x64_mingw]
gem 'rspec'
