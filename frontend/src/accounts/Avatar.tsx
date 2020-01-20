import React from "react";
import { User } from "./model";
import { Image } from "semantic-ui-react";

type Props = {
  user: User;
};

function Avatar({ user }: Props) {
  return (
    <Image src={`https://api.adorable.io/avatars/40/${user.id}.png`} rounded />
  );
}

export default Avatar;
