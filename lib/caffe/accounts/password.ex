defmodule Caffe.Accounts.Password do
  @library Argon2

  def hash(password) do
    @library.hash_pwd_salt(password)
  end

  def valid?(plain_password, hashed_password) do
    @library.verify_pass(plain_password, hashed_password)
  end
end
