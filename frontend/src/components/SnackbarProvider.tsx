import React, { Fragment, useState, createContext, useContext } from "react";
import Snackbar from "@material-ui/core/Snackbar";
import IconButton from "@material-ui/core/IconButton";
import CloseIcon from "@material-ui/icons/Close";
import { makeStyles } from "@material-ui/core/styles";
import { green, amber } from "@material-ui/core/colors";
import SnackbarContent from "@material-ui/core/SnackbarContent";

type SnackbarVariant = "success" | "error" | "info" | "warning";

type SnackbarOpts = {
  autoHideDuration?: number;
  variant?: SnackbarVariant;
};

type ContextValue = {
  showSnackbar: (message: string, opts?: SnackbarOpts) => void;
};

type State = {
  open: boolean;
  message: string;
  autoHideDuration: number;
  variant: SnackbarVariant;
};

const SnackbarContext = createContext<ContextValue>({ showSnackbar: () => {} });

const useStyles = makeStyles(theme => ({
  success: {
    backgroundColor: green[600]
  },
  error: {
    backgroundColor: theme.palette.error.dark
  },
  info: {},
  warning: {
    backgroundColor: amber[700]
  }
}));

const SnackbarProvider: React.FC = ({ children }) => {
  const classes = useStyles();

  const [state, setState] = useState<State>({
    open: false,
    message: "",
    autoHideDuration: 3000,
    variant: "info"
  });
  const { open, variant, message, ...opts } = state;

  const handleClose = (event: any, reason?: string) => {
    if (reason === "clickaway") return;
    setState({ ...state, open: false });
  };

  const contextValue: ContextValue = {
    showSnackbar(message, opts = {}) {
      setState({ ...state, message, ...opts, open: true });
    }
  };

  return (
    <Fragment>
      <SnackbarContext.Provider value={contextValue}>
        {children}
      </SnackbarContext.Provider>

      <Snackbar
        open={open}
        onClose={handleClose}
        anchorOrigin={{
          vertical: "bottom",
          horizontal: "left"
        }}
        {...opts}
      >
        <SnackbarContent
          message={message}
          className={classes[variant]}
          action={[
            <IconButton
              key="close"
              aria-label="close"
              color="inherit"
              onClick={handleClose}
            >
              <CloseIcon />
            </IconButton>
          ]}
        />
      </Snackbar>
    </Fragment>
  );
};

export const useSnackbar = () => useContext(SnackbarContext);

export default SnackbarProvider;
