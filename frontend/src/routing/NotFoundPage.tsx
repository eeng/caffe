import React from "react";
import { Header, Icon, Segment } from "semantic-ui-react";
import "./NotFoundPage.less";
import { Link } from "react-router-dom";

function NotFoundPage() {
  return (
    <div className="NotFoundPage">
      <Segment>
        <Header as="h2" icon>
          <Icon name="meh outline" />
          Error 404
          <Header.Subheader className="message">
            Looks like the page you're looking for has been removed or doesn't
            exist.
          </Header.Subheader>
          <Header.Subheader>
            <Link to="/">Return to Home Page</Link>
          </Header.Subheader>
        </Header>
      </Segment>
    </div>
  );
}

export default NotFoundPage;
