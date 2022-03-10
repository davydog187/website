window.Prism = window.Prism || {};
window.Prism.manual = true;

import Prism from "prismjs";
import 'prismjs/components/prism-json';
import 'prismjs/components/prism-elixir';

export default {
    prism: {
        highlight(el) {
            Array.from(el.getElementsByTagName("code")).map(code => Prism.highlightElement(code));
        },
        mounted() {
            console.log("prism", this.el)
            this.highlight(this.el)

            // Call it again to fix misplaced selected lines on page reload
            this.highlight(this.el)

        }
    }
};
