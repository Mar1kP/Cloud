#!/bin/bash


aws lambda invoke --function-name my-s3-function out --log-type Tail
aws lambda invoke --function-name my-s3-function out --log-type Tail \
--query 'LogResult' --output text |  base64 -d
aws lambda get-function --function-name my-s3-function

#https://prod-iad-c1-djusa-tasks.s3.us-east-1.amazonaws.com/snapshots/141848694151/my-s3-function-e32dc383-a466-41d3-aeca-605822ff891d?versionId=vdJDd7qSDvg80fRYbDKLgyvqIcyd9GuN&X-Amz-Security-Token=IQoJb3JpZ2luX2VjECwaCXVzLWVhc3QtMSJHMEUCIQDTRHIdp35wR4cPuAPQpaE8FdBDUj7NFhdXFdeRKJ2lAAIgJkbvM2PV5KpGk9dIAwAVmsOCfBOcNcpa1DE3cSZCcbQqzAQIVBADGgw0NzkyMzMwMjUzNzkiDHja0Lo%2BDHMYBqBHjSqpBFAaC88o5N0pG8Qu5opBSksQJqkMLBhGFmhG%2FfMalkMqX5lgG%2BXB1qgDZmh4idLYfWL2oLmdbVYmM%2BEX5y%2FDeAP0KZLGYFUwUcWWyGuk06u4EN0hJ3r%2BLLQWxE6TPeeebBcFxERrEh81UKWWbL9TIz6j5c0FsTsedgfn5dUziLWrs%2F%2FYdvCgZdvHATYgxEUZo9JOw%2FqCtvK9EE7EVccPd%2F6oN9Pv6FCN%2FGMvENLuF3FYNp0qbIzqLvbSsQ44sp8MwGa0%2FhhSKQr11f00W48qgRP0zjg5LYiLhgVTMii66HZL%2BragLSBo9osvrg6bmoB026Cw%2BAVPNXOEPhuCml1BYBd%2B6KClppA4ePqpxjoi9XwBn7%2BuAEtvMBWTjvwv5AmUZjKYLkI2oeq87iBGu7%2BheUu%2Fi7Az9N%2BOirkeEaPD2hP4%2FQIwcREoLy4o1NZmizMwSzZfCRifTfSCbz9pHPewvCEKzXjxqWie3VpW2AMb20Kvu%2FFU0pRqKoX5XZRxJFNS4rsNDMLtYV3CNYrJk1%2FxljSXUL3IucY4FfsNbdat%2BFFcsON31i8ILJfPqFcSz8vrpIMPi%2BJah9hpUg13wY%2BH1VhBQ6AOg0ZGrhqGEEtgOy3bUvDMgFxSiCgwsQgkIpsaYAPoIYFHFAdckZXuht8XJa3O6sjCJ8urirDO5vbSN5mKVl2lUpMPpCeUDIhS97%2FABmb5uVhTnpYsPD7Pg7P1IeSpE9QB1ETOq%2Fow49HKnAY6qQEz1YV8fEQk6HDwm3hDlXzlhf7C9tlk4q6lRI6O8Sh33NFnobd1xEUZgcf32EcFuoQwxJerNwyAY%2BrB6ZdJwtMVNrKJxsu1Y9VXfYjar%2BnVBQ3MI8fRL3V5UlC1deeWxzrwwvRgaJhUO9lWkefVHtNiXwHOw1yxNSFOahoxBGIxGS8WdtkEK3Xo1bj46K%2BLIwAf3ntDCYFWadY72og6VH9Oddq5QChh8OQa&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20221209T051544Z&X-Amz-SignedHeaders=host&X-Amz-Expires=600&X-Amz-Credential=ASIAW7FEDUVR6K6JIFHV%2F20221209%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=ead90a3a4965290480372c53ec0a3b41e664e0056652df342bd29ec76185122d