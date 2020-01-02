import React, { useState, useEffect } from "react";
import styles from "./LoginPage.module.css";
import { Credentials, useAuth, AuthStatus } from "./AuthProvider";
import { useHistory, useLocation } from "react-router-dom";
import { Grid, Header, Icon, Form, Segment, Button } from "semantic-ui-react";
import { toast } from "react-semantic-toasts";

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
        type: "error"
      });
    }
  }, [status]);

  const handleChange = (_event: any, { name, value }: any) => {
    setCredentials({ ...credentials, [name]: value });
  };

  function handleSubmit() {
    login(credentials);
  }

  return (
    <Grid textAlign="center" verticalAlign="middle" className={styles.grid}>
      <Grid.Column className={styles.column}>
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
            >
              Login
            </Button>
          </Segment>
        </Form>
      </Grid.Column>
    </Grid>
  );
}

export default LoginPage;
