import { MenuItem } from "components/configuration/MenuSection";
import { MockedResponse } from "@apollo/client/testing";
import { DocumentNode } from "@apollo/client";
import { User } from "components/AuthProvider";

function sequenceGen() {
  let n = 1;
  return {
    next() {
      return n++;
    }
  };
}

const sequence = sequenceGen();

interface MockQueryOpts {
  variables?: Record<string, any>;
}

export function mockQuery(
  query: DocumentNode,
  { variables = {} }: MockQueryOpts = {}
) {
  const baseResponse = {
    request: {
      query: query,
      variables: variables
    }
  };

  return {
    returnsData(data: any): MockedResponse {
      return {
        ...baseResponse,
        result: {
          data: data
        }
      };
    },

    returnsError(error: any): MockedResponse {
      return {
        ...baseResponse,
        error: error
      };
    }
  };
}

export function user(fields?: Partial<User>) {
  return {
    id: sequence.next(),
    name: "User name",
    email: "user@acme.com",
    permissions: [],
    ...fields
  };
}

export function menuItem(fields?: Partial<MenuItem>) {
  return {
    id: sequence.next(),
    name: "Burger",
    price: "10.5",
    isDrink: false,
    description: "",
    category: { name: "Food" },
    ...fields
  };
}
