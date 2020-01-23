import { gql, useMutation } from "@apollo/client";
import React, { useState } from "react";
import { toast } from "react-semantic-toasts";
import { Button, ButtonProps, Form, Modal } from "semantic-ui-react";
import { OrderDetails } from "../model";
import { formatCurrency } from "/lib/format";

interface Props extends ButtonProps {
  order: OrderDetails;
  refetchQueries?: any[];
}

function PayOrderButton({ order, refetchQueries = [], ...rest }: Props) {
  if (order.state != "served") return null;

  const [open, setOpen] = useState(false);

  const openModal = () => setOpen(true);
  const closeModal = () => setOpen(false);

  return (
    <Modal
      trigger={
        <Button
          secondary
          content="Pay"
          onClick={openModal}
          className="PayButton"
          {...rest}
        />
      }
      open={open}
      onClose={closeModal}
      size="mini"
    >
      <Modal.Header>Paying Order {order.code}</Modal.Header>
      <ModalBody
        order={order}
        closeModal={closeModal}
        refetchQueries={refetchQueries}
      />
    </Modal>
  );
}

const PAY_ORDER_MUTATION = gql`
  mutation($orderId: ID!, $amountPaid: String) {
    payOrder(orderId: $orderId, amountPaid: $amountPaid)
  }
`;

function ModalBody({
  order,
  closeModal,
  refetchQueries
}: {
  order: OrderDetails;
  closeModal: () => any;
  refetchQueries: any[];
}) {
  const { orderAmount } = order;

  // the double toString is to remove additional zeroes
  const [formData, setFormData] = useState({
    amountPaid: parseFloat(orderAmount.toString()).toString()
  });

  const [payOrder, { loading }] = useMutation(PAY_ORDER_MUTATION, {
    variables: { ...formData, orderId: order.id },
    refetchQueries: refetchQueries
  });

  const amountPaid = parseFloat(formData.amountPaid) || 0;
  const tipAmount = Math.max(amountPaid - orderAmount, 0);

  const isInvalid = amountPaid < orderAmount;

  function handleSubmit() {
    payOrder().then(() => {
      toast({
        title: "Thanks!",
        description: "Your payment has been registered.",
        type: "success",
        icon: "dollar",
        time: 5000
      });
    });
  }

  return (
    <>
      <Modal.Content>
        <Form onSubmit={handleSubmit}>
          <Form.Input
            label="Order Amount"
            readOnly
            defaultValue={formatCurrency(orderAmount)}
          />
          <Form.Input
            label="Amount Paid"
            autoFocus
            value={formData.amountPaid}
            onChange={(_, { value }) => setFormData({ amountPaid: value })}
            error={isInvalid}
          />
          <Form.Input
            label="Tip Amount"
            readOnly
            value={formatCurrency(tipAmount)}
          />
        </Form>
      </Modal.Content>

      <Modal.Actions>
        <Button content="Cancel" onClick={closeModal} />
        <Button
          content="Confirm"
          onClick={handleSubmit}
          positive
          loading={loading}
          disabled={loading || isInvalid}
        />
      </Modal.Actions>
    </>
  );
}

export default PayOrderButton;
