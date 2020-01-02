import React, { useState, useEffect } from "react";
import Container from "@material-ui/core/Container";
import Avatar from "@material-ui/core/Avatar";
import Typography from "@material-ui/core/Typography";
import TextField from "@material-ui/core/TextField";
import Button from "@material-ui/core/Button";
import FormControl from "@material-ui/core/FormControl";
import InputLabel from "@material-ui/core/InputLabel";
import OutlinedInput from "@material-ui/core/OutlinedInput";
import InputAdornment from "@material-ui/core/InputAdornment";
import IconButton from "@material-ui/core/IconButton";
import LockOutlined from "@material-ui/icons/LockOutlined";
import Visibility from "@material-ui/icons/Visibility";
import VisibilityOff from "@material-ui/icons/VisibilityOff";
import { makeStyles } from "@material-ui/core/styles";
import { Credentials, useAuth, AuthStatus } from "./AuthProvider";
import { useSnackbar } from "./SnackbarProvider";

const useStyles = makeStyles(theme => ({
  paper: {
    marginTop: theme.spacing(8),
    display: "flex",
    flexDirection: "column",
    alignItems: "center"
  },
  avatar: {
    margin: theme.spacing(1),
    backgroundColor: theme.palette.secondary.main
  },
  form: {
    marginTop: theme.spacing(1)
  },
  submit: {
    margin: theme.spacing(3, 0, 2)
  }
}));

function LoginPage() {
  const classes = useStyles();

  const [showPassword, setShowPassword] = useState(false);
  const [credentials, setCredentials] = useState<Credentials>({
    email: "",
    password: ""
  });

  const { login, status } = useAuth();
  const { showSnackbar } = useSnackbar();

  useEffect(() => {
    if (status == AuthStatus.LoggingFailed)
      showSnackbar("Invalid email or password.", { variant: "error" });
  }, [status]);

  const handleChange = (prop: string) => (event: any) => {
    setCredentials({ ...credentials, [prop]: event.target.value });
  };

  function handleSubmit(e: React.FormEvent) {
    login(credentials);
    e.preventDefault();
  }

  return (
    <Container maxWidth="xs">
      <div className={classes.paper}>
        <Avatar className={classes.avatar}>
          <LockOutlined />
        </Avatar>
        <Typography component="h1" variant="h5">
          Sign In
        </Typography>

        <form className={classes.form} noValidate onSubmit={handleSubmit}>
          <TextField
            label="Email"
            variant="outlined"
            margin="normal"
            fullWidth
            autoFocus
            autoComplete="email"
            value={credentials.email}
            onChange={handleChange("email")}
          />
          <FormControl variant="outlined" fullWidth>
            <InputLabel htmlFor="password">Password</InputLabel>
            <OutlinedInput
              id="password"
              type={showPassword ? "text" : "password"}
              value={credentials.password}
              onChange={handleChange("password")}
              endAdornment={
                <InputAdornment position="end">
                  <IconButton
                    edge="end"
                    onClick={() => setShowPassword(!showPassword)}
                  >
                    {showPassword ? <Visibility /> : <VisibilityOff />}
                  </IconButton>
                </InputAdornment>
              }
              labelWidth={70}
            />
          </FormControl>
          <Button
            type="submit"
            variant="contained"
            color="primary"
            size="large"
            fullWidth
            className={classes.submit}
            disabled={status == AuthStatus.LoggingIn}
          >
            Sign In
          </Button>
        </form>
      </div>
    </Container>
  );
}

export default LoginPage;
