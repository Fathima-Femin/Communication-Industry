/**
 * AccountNumber resolver PATCH extensibility handler for Customer Management.
 * Demonstrates how to resolve AccountNumber to Salesforce ID for PATCH operations.
 * Uses transformRequest to map AccountNumber to Salesforce ID.
 * Used in functional tests to verify unique identifier resolution works correctly for PATCH.
 */
//public class AccountNumberResolverPatchExt implements comms_apex_ext.ICustomerManagementPATCH {
public class AccountNumberResolverPatchExt {
    /**
     * Transforms request context, resolving AccountNumber to Salesforce ID if needed.
     * This method is called early in the request processing to resolve alternative identifiers
     * (like AccountNumber) to Salesforce IDs that are used for subsequent operations.
     * Uses SOQL to query Account objects where AccountNumber matches the ID in the context.
     * 
     * @param context Request context containing API details including the ID field
     * @return Transformed context with resolved Salesforce ID if AccountNumber was provided
     */
    public Map<String, Object> transformRequest(Map<String, Object> context) {
        if (context == null) {
            return context;
        }
        
        Object idObj = context.get('id');
        
        
        String idValue = (String)idObj;
        
        // Query Account objects where AccountNumber matches the provided ID
        List<Account> accounts = [
            SELECT Id, AccountNumber 
            FROM Account 
            WHERE AccountNumber = :idValue
            LIMIT 1
        ];
        
        // If found, replace the ID in context with the Salesforce ID
        if (!accounts.isEmpty() && accounts[0].Id != null) {
            context.put('id', accounts[0].Id);
        }
        
        return context;
    }
    
    /**
     * Configures default validation settings.
     * Returns empty map to use all default validations without modification.
     */
    public Map<String, Boolean> configureDefaultValidations(Map<String, Object> defaultValidationConfiguration, Map<String, Object> context) {
        return new Map<String, Boolean>();
    }
    
    /**
     * Customizes the GraphQL query used to fetch data.
     * Returns empty map to use default query without modifications.
     */
    public Map<String, Object> customiseGraphQLQuery(Map<String, Object> graphQLAsMap, Map<String, Object> context) {
        return new Map<String, Object>();
    }
    
    /**
     * Handles post-processing after the PATCH operation completes.
     * Returns the constructed response without modification.
     */
    public Map<String, Object> handlePostOperation(Map<String, Object> graphQLQueryResultAsMap, Map<String, Object> constructedTMFResponse, Map<String, Object> context) {
        return constructedTMFResponse;
    }
    
    /**
     * Applies custom validations to the PATCH request.
     * Returns empty map indicating no custom validation errors.
     */
    public Map<String, Object> applyCustomValidations(Map<String, Object> context) {
        return new Map<String, Object>();
    }
    
    /**
     * Customizes the mutation payload before the GraphQL mutation is executed.
     * Returns the request without modification.
     */
   public Map<String, Object> customiseMutationPayload(Map<String, Object> request, Map<String, Object> context) {
        // Return mutation transformation instructions: add Account fields at alias path "customerAccount"
        Map<String, Object> nodes0 = new Map<String, Object>();
        nodes0.put('path', 'customerAccount');
        Map<String, Object> addFields = new Map<String, Object>();
        
        // Read Description and Industry from request body in context
        Map<String, Object> requestBody = (Map<String, Object>)context.get('requestBody');
        if (requestBody != null) {
            String description = (String)requestBody.get('description');
            String industry = (String)requestBody.get('industry');
            
            // Add Description to Account if present in request
            if (description != null) {
                addFields.put('Description', description);
            }
            // Add Industry to Account if present in request
            if (industry != null) {
                addFields.put('Industry', industry);
            }
        }
        
        nodes0.put('addFields', addFields);

        // Build nodes array containing the transformation instructions
        List<Object> nodes = new List<Object>();
        nodes.add(nodes0);

        // Return result with nodes array
        Map<String, Object> result = new Map<String, Object>();
        result.put('nodes', nodes);
        return result;
    }
}