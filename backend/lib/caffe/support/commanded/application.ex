defmodule Caffe.Commanded.Application do
  use Commanded.Application, otp_app: :caffe

  router(Caffe.Router)
end
