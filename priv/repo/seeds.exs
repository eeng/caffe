unless Mix.env() == :test do
  Caffe.Seeds.run()
end
