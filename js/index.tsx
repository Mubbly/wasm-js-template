import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Hello } from './components/Hello';

import('../pkg/main_crate').then(module => {
    module.load();
});

ReactDOM.render(
    <Hello compiler="Typescript" framework="React" />,
    document.getElementById('root'),
);
