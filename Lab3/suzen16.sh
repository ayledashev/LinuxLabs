#!/bin/bash
echo "Ключ suzen16 это: $(sed -n '/:1000:root/p' /etc/group |cut -c -28)"
