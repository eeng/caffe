import React from "react";
import { makeStyles } from "@material-ui/core/styles";
import CircularProgress from "@material-ui/core/CircularProgress";
import Box from "@material-ui/core/Box";

const useStyles = makeStyles(theme => ({
  paper: {
    display: "flex",
    justifyContent: "center",
    marginTop: theme.spacing(10)
  }
}));

const FullScreenSpinner: React.FC = () => {
  const classes = useStyles();

  return (
    <Box height="100%">
      <div className={classes.paper}>
        <CircularProgress />
      </div>
    </Box>
  );
};

export default FullScreenSpinner;
