module.exports = {
  roots: ["<rootDir>/src"],
  testMatch: [
    "**/__tests__/**/*.+(ts|tsx|js)",
    "**/?(*.)+(spec|test).+(ts|tsx|js)"
  ],
  transform: {
    "^.+\\.(ts|tsx)$": "ts-jest"
  },
  globals: {
    // Improves the tests speed a litte bit
    "ts-jest": {
      isolatedModules: true
    }
  },
  moduleNameMapper: {
    "\\.(css|less)$": "<rootDir>/src/__mocks__/styleMock.ts",

    // Matches Parcel module resolution
    "^/(.*)$": "<rootDir>/src/$1",
    "^~/(.*)$": "<rootDir>/$1"
  }
};
