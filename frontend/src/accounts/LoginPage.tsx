import React, { useEffect, useState } from "react";
import { useHistory, useLocation } from "react-router-dom";
import { toast } from "react-semantic-toasts";
import {
  Button,
  Form,
  Grid,
  Header,
  Icon,
  InputOnChangeData,
  Segment
} from "semantic-ui-react";
import { AuthStatus, Credentials, useAuth } from "./AuthProvider";
import "./LoginPage.less";

function LoginPage() {
  const [credentials, setCredentials] = useState<Credentials>({
    email: "",
    password: ""
  });

  const { login, status } = useAuth();
  const history = useHistory();
  const location = useLocation();

  useEffect(() => {
    if (status == AuthStatus.LoggedIn) {
      const { from } = location.state || { from: { pathname: "/" } };
      history.replace(from);
    } else if (status == AuthStatus.LoggingFailed) {
      toast({
        title: "Oops",
        description: "Invalid email or password",
        type: "error",
        icon: "lock"
      });
    }
  }, [status]);

  const handleChange = (_event: any, { name, value }: InputOnChangeData) => {
    setCredentials({ ...credentials, [name]: value });
  };

  function handleSubmit() {
    login(credentials);
  }

  return (
    <Grid textAlign="center" verticalAlign="middle" className="LoginPage">
      <Grid.Column>
        <Header as="h2" icon textAlign="center">
          <Icon name="lock" circular />
          <Header.Content>Sign In</Header.Content>
        </Header>

        <Form onSubmit={handleSubmit}>
          <Segment stacked>
            <Form.Input
              fluid
              icon="user"
              iconPosition="left"
              placeholder="E-mail address"
              name="email"
              onChange={handleChange}
              autoFocus
            />
            <Form.Input
              fluid
              icon="lock"
              iconPosition="left"
              placeholder="Password"
              type="password"
              name="password"
              onChange={handleChange}
            />

            <Button
              primary
              fluid
              size="large"
              disabled={status == AuthStatus.LoggingIn}
              loading={status == AuthStatus.LoggingIn}
              content="Login"
            />
          </Segment>
        </Form>
      </Grid.Column>
    </Grid>
  );
}

export default LoginPage;
