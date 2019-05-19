#!/bin/bash
echo "Flag is: $(sed -n '/:1000:root/p' /etc/group |cut -c -28)"
