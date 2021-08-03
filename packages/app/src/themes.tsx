import { createTheme, lightTheme, genPageTheme, darkTheme } from '@backstage/theme';

const lightThemeVA = createTheme({
    palette: {
        ...lightTheme.palette,
        // Primary button color
        primary: {
            main: '#2e77d0',
        },
        // Colors for side nav bar
        navigation: {
            background: '#112e51',
            indicator: '#fac922',
            color: '#ffffff',
            selectedColor: '#fac922',
        },
        background: {
            default: '#f1f1f1',
            paper: '#ffffff',
        },
    },
    fontFamily:
        'Source Sans Pro,Helvetica Neue,Helvetica,Roboto,Arial,sans-serif',
    defaultPageTheme: 'home',
    // Colors for headers
    pageTheme: {
        home: genPageTheme(['#112e51','#112e51'], 'none'), 
        documentation: genPageTheme(['#112e51','#112e51'], 'none'),
        tool: genPageTheme(['#112e51','#112e51'], 'none'),
        service: genPageTheme(['#112e51','#112e51'], 'none'),
        website: genPageTheme(['#112e51','#112e51'], 'none'),
        library: genPageTheme(['#112e51','#112e51'], 'none'),
        other: genPageTheme(['#112e51','#112e51'], 'none'),
        app: genPageTheme(['#112e51','#112e51'], 'none'),
        apis: genPageTheme(['#112e51','#112e51'], 'none'),
    }
});

const darkThemeVA = createTheme({
    palette: {
        ...darkTheme.palette,
        // Primary button colors
        primary: {
            main: '#94bfa2',
        },
        // Colors for side nav bar
        navigation: {
            background: '#323a45',
            indicator: '#4aa564',
            color: '#d6d7d9',
            selectedColor: '#4aa564',
        },
        background: {
            // Default dark theme colors
            // This may need to change to the recommended VA grayscale colors
            default: '#333333',
            paper: '#424242',
        },
    },
    fontFamily:
      'Source Sans Pro,Helvetica Neue,Helvetica,Roboto,Arial,sans-serif',
    defaultPageTheme: 'home',
    // Colors for headers
    pageTheme: {
        home: genPageTheme(['#323a45','#323a45'], 'none'),
        documentation: genPageTheme(['#323a45','#323a45'], 'none'),
        tool: genPageTheme(['#323a45','#323a45'], 'none'),
        service: genPageTheme(['#323a45','#323a45'], 'none'),
        website: genPageTheme(['#323a45','#323a45'], 'none'),
        library: genPageTheme(['#323a45','#323a45'], 'none'),
        other: genPageTheme(['#323a45','#323a45'], 'none'),
        app: genPageTheme(['#323a45','#323a45'], 'none'),
        apis: genPageTheme(['#323a45','#323a45'], 'none'),
    }
});

export { lightThemeVA, darkThemeVA };
