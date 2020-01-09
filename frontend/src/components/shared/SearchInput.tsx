import React, { useRef } from "react";
import { Input, Icon, InputProps } from "semantic-ui-react";

interface Props extends InputProps {
  search: string;
  onSearch: (search: string) => void;
}

function SearchInput({ search, onSearch, ...rest }: Props) {
  const searchRef = useRef<Input>(null);

  return (
    <Input
      icon={
        search ? (
          <Icon
            name="delete"
            link
            onClick={() => {
              onSearch("");
              searchRef.current && searchRef.current.focus();
            }}
            title="Clear Search"
          />
        ) : (
          <Icon name="search" />
        )
      }
      ref={searchRef}
      placeholder="Search..."
      value={search}
      onChange={(_, { value }) => onSearch(value)}
      {...rest}
    />
  );
}

export default SearchInput;
