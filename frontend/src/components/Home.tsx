import React from "react";
import AppBar from "@material-ui/core/AppBar";
import Toolbar from "@material-ui/core/Toolbar";
import Typography from "@material-ui/core/Typography";
import Button from "@material-ui/core/Button";
import { makeStyles } from "@material-ui/core/styles";
import { useAuth } from "./AuthProvider";

const useStyles = makeStyles(theme => ({
  title: {
    flexGrow: 1
  }
}));

function Home() {
  const classes = useStyles();
  const { logout } = useAuth();

  return (
    <>
      <AppBar position="fixed">
        <Toolbar>
          <Typography variant="h6" className={classes.title}>
            Home
          </Typography>
          <Button color="inherit" onClick={() => logout()}>
            Logout
          </Button>
        </Toolbar>
      </AppBar>
      <Toolbar />
      <div>
        Lorem ipsum dolor, sit amet consectetur adipisicing elit. Veritatis quas
        quos blanditiis sint adipisci architecto inventore earum fugit culpa
        nostrum saepe neque incidunt accusamus tenetur ipsam debitis facere,
        repellat labore.
      </div>
    </>
  );
}

export default Home;
